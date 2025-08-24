//
//  DriverMainView.swift
//  LetHimCook
//
//  Created by 김민석 on 8/23/25.
//

import SwiftUI
struct DriverMainView: View {
    @EnvironmentObject var multipeer: MultipeerSession
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                let center = CGPoint(x: geo.size.width/2, y: geo.size.height/2)
                let maxRingRadius = min(geo.size.width, geo.size.height) * 0.65
                
                // Reactive layout: subscribe to nbi so UI updates with distance changes
                if let nbi = multipeer.nbiManager {
                    // Background rings react to distance (safe ↔ alert)
                    AlertAwareBackground(center: center, maxRingRadius: maxRingRadius, nbi: nbi)
                        .zIndex(0)
                    
                    // Remote target (position/appearance reacts to distance/azimuth)
                    NBIOverlay(center: center, nbi: nbi)
                        .zIndex(1)
                    
                    // My center circle reacts to distance (blue when safe, white when alert)
                    CenterCircle(center: center, nbi: nbi)
                        .zIndex(2)
                    
                    // Critical STOP overlay (<= 1m)
                    CriticalStopOverlay(nbi: nbi)
                        .zIndex(3)
                } else {
                    Text("UWB 준비 중…")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .position(center)
                        .zIndex(1)
                }
            }
        }
        .onAppear { multipeer.attachNearbyInteraction()
        }
    }
}

private struct NBIOverlay: View {
    let center: CGPoint
    @ObservedObject var nbi: NearbyInteractionManager
    
    @State private var lastAzimuth: Double? = nil
    
    private let minRadius: CGFloat = 20
    private let maxRadius: CGFloat = 140
    private let distanceScale: CGFloat = 45
    
    var body: some View {
        // azimuth가 nil이면 마지막 유효값 사용, 없으면 0
        let az = (nbi.azimuth ?? lastAzimuth) ?? 0
        let dist = nbi.distance ?? .infinity
        let shownDist = dist.quantizedForDisplay
        let isAlert: Bool = (shownDist <= 3) // display-aligned threshold
        
        // 캐시 갱신
        if let currentAz = nbi.azimuth { lastAzimuth = currentAz }
        
        // 거리(표시 단위와 동일한 양자화) → 반경(px)
        let quantizedMeters = max(0.0, shownDist)
        let rawRadius = CGFloat(quantizedMeters) * distanceScale
        let radius = max(minRadius, min(rawRadius, maxRadius))
        
        // 화면 좌표(Driver 기기 전방=0, 오른쪽 +)
        let dx = radius * CGFloat(sin(az))
        let dy = radius * CGFloat(-cos(az))
        let target = CGPoint(x: center.x + dx, y: center.y + dy)
        
        return Group {
            // Target circle
            Circle()
                .fill(isAlert ? Color.red : Color.white)
                .frame(width: 70, height: 70)
                .overlay(
                    Circle().stroke(isAlert ? Color.red : Color.blue, lineWidth: 2)
                )
                .position(target)
            
            // Distance label BELOW the circle (about 48pt down)
            if shownDist.isFinite {
                Text(shownDist.displayString)
                    .font(.caption2)
                    .foregroundStyle(isAlert ? Color.white.opacity(0.95) : .secondary)
                    .position(CGPoint(x: target.x, y: target.y + 48))
            }
        }
        .animation(.easeOut(duration: 0.12), value: az)
        .animation(.easeOut(duration: 0.12), value: shownDist)
    }
}

// MARK: - Critical STOP overlay (<= 1m)
private struct CriticalStopOverlay: View {
    @ObservedObject var nbi: NearbyInteractionManager
    
    private var show: Bool {
        let sd = (nbi.distance ?? .infinity).quantizedForDisplay
        return sd <= 1
    }
    
    var body: some View {
        Group {
            if show {
                GeometryReader { geo in
                    Color.red.ignoresSafeArea(.all)
                    Text("STOP")
                        .font(.system(size: min(geo.size.width, geo.size.height) * 0.28,
                                      weight: .black,
                                      design: .rounded))
                        .kerning(2)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 4)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .position(x: geo.size.width/2, y: geo.size.height/2.5)
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.15), value: show)
    }
}

// MARK: - Reactive background rings by distance
private struct AlertAwareBackground: View {
    let center: CGPoint
    let maxRingRadius: CGFloat
    @ObservedObject var nbi: NearbyInteractionManager
    
    private var isAlert: Bool {
        let sd = (nbi.distance ?? .infinity).quantizedForDisplay
        return sd <= 3
    }
    
    var body: some View {
        ConcentricRings(center: center,
                        maxRadius: maxRingRadius,
                        theme: isAlert ? .redAlert : .blueSafety)
        .animation(.easeOut(duration: 0.15), value: isAlert)
    }
}

// MARK: - Reactive center circle by distance
private struct CenterCircle: View {
    let center: CGPoint
    @ObservedObject var nbi: NearbyInteractionManager
    
    private var isAlert: Bool {
        let sd = (nbi.distance ?? .infinity).quantizedForDisplay
        return sd <= 3
    }
    
    var body: some View {
        Circle()
            .fill(isAlert ? Color.white : Color.blue) // 안전: 파랑, 경고: 흰색
            .frame(width: 55, height: 55)
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
            .overlay(
                Text("나")
                    .font(.headline)
                    .foregroundColor(isAlert ? Color.primary : Color.white)
            )
            .position(center)
            .animation(.easeOut(duration: 0.15), value: isAlert)
    }
}

// MARK: - Reusable concentric rings (background safety rings)
struct ConcentricRings: View {
    let center: CGPoint
    let radii: [CGFloat]
    let theme: Theme
    
    enum Theme {
        case blueSafety
        case redAlert
        
        var gradientPairs: [(start: Color, end: Color)] {
            switch self {
            case .blueSafety:
                return [
                    (Color.blue.opacity(0.40), Color.blue.opacity(0.18)), // inner
                    (Color.blue.opacity(0.30), Color.blue.opacity(0.12)), // middle
                    (Color.blue.opacity(0.22), Color.blue.opacity(0.08))  // outer
                ]
            case .redAlert:
                return [
                    (Color.red.opacity(0.52), Color.red.opacity(0.20)), // inner
                    (Color.red.opacity(0.32), Color.red.opacity(0.14)), // middle
                    (Color.red.opacity(0.24), Color.red.opacity(0.10))  // outer
                ]
            }
        }
    }
    
    init(center: CGPoint, radii: [CGFloat], theme: Theme = .blueSafety) {
        self.center = center
        self.radii = radii
        self.theme = theme
    }
    
    /// Convenience init: supply just a max radius. The other two are derived.
    init(center: CGPoint, maxRadius: CGFloat, theme: Theme = .blueSafety) {
        self.init(center: center,
                  radii: [maxRadius * 0.38, maxRadius * 0.72, maxRadius],
                  theme: theme)
    }
    
    var body: some View {
        ZStack {
            ForEach(radii.indices, id: \.self) { idx in
                let pair = theme.gradientPairs[min(idx, theme.gradientPairs.count - 1)]
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [pair.start, pair.end]),
                            center: .center,
                            startRadius: 0,
                            endRadius: radii[idx]
                        )
                    )
                    .frame(width: radii[idx] * 2, height: radii[idx] * 2)
                    .position(center)
            }
        }
        .allowsHitTesting(false)
    }
}

private extension Double {
    /// 항상 1m 단위로 표시
    var displayString: String {
        if !self.isFinite { return "0 m" }
        return String(format: "%.0f m", self.rounded())
    }
    
    /// 항상 1m 단위로 반경 계산
    var quantizedForDisplay: Double {
        guard self.isFinite else { return .infinity } // non-finite => treat as safe
        return self.rounded()
    }
}

#Preview {
    DriverMainView()
        .environmentObject(MultipeerSession(displayName: "test"))
}
