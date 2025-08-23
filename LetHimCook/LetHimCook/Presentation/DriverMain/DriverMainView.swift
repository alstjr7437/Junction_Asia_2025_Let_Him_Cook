//
//  DriverMainView.swift
//  LetHimCook
//
//  Created by 김민석 on 8/23/25.
//

import SwiftUI
struct DriverMainView: View {
    @ObservedObject var multipeer: MultipeerSession

    var body: some View {
        ZStack {
            GeometryReader { geo in
                let center = CGPoint(x: geo.size.width/2, y: geo.size.height/2)

                Circle()
                    .fill(Color.blue.opacity(0.25))
                    .frame(width: 80, height: 80)
                    .overlay(Text("나").font(.headline))
                    .position(center)

                if let nbi = multipeer.nbiManager {
                    NBIOverlay(center: center, nbi: nbi)
                } else {
                    Text("UWB 준비 중…")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .position(center)
                }
            }
        }
        .onAppear { multipeer.attachNearbyInteraction() }
        .navigationTitle("Driver")
        .navigationBarTitleDisplayMode(.inline)
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

        // Driver 기준 상대 방향 라벨(8방위)
        let dirLabel = sectorLabel(from: az)

        return Group {
            Circle()
                .fill(Color.green.opacity(0.25))
                .frame(width: 72, height: 72)
                .overlay(
                    VStack(spacing: 6) {
                        Text(dirLabel) // ← "앞/오른쪽/뒤…" 등
                            .font(.subheadline)
                        if nbi.distance != nil {
                            Text(shownDist.displayString)
                                .font(.caption).foregroundStyle(.secondary)
                        } else {
                            Text("측정 중…").font(.caption).foregroundStyle(.secondary)
                        }
                    }
                )
                .position(target)
        }
        .animation(.easeOut(duration: 0.12), value: az)
        .animation(.easeOut(duration: 0.12), value: shownDist)
    }

    /// Driver 기기 기준 8방위 라벨
    private func sectorLabel(from azimuth: Double) -> String {
        // 0=앞(위), 시계방향 +, 45도(π/4) 단위
        let deg = (azimuth * 180.0 / .pi)
        let norm = (deg < 0 ? deg + 360 : deg).truncatingRemainder(dividingBy: 360)

        switch norm {
        case 337.5...360, 0..<22.5:   return "앞"
        case 22.5..<67.5:             return "앞-오른쪽"
        case 67.5..<112.5:            return "오른쪽"
        case 112.5..<157.5:           return "뒤-오른쪽"
        case 157.5..<202.5:           return "뒤"
        case 202.5..<247.5:           return "뒤-왼쪽"
        case 247.5..<292.5:           return "왼쪽"
        case 292.5..<337.5:           return "앞-왼쪽"
        default:                      return "?"
        }
    }
}

#Preview {
    DriverMainView(multipeer: MultipeerSession(displayName: "Preview"))
}

private extension Double {
    /// 항상 1m 단위로 표시
    var displayString: String {
        if !self.isFinite { return "0 m" }
        return String(format: "%.0f m", self.rounded())
    }

    /// 항상 1m 단위로 반경 계산
    var quantizedForDisplay: Double {
        guard self.isFinite else { return 0 }
        return self.rounded()
    }
}
