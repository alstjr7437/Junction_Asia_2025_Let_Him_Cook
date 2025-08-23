//
//  SignalManMainView.swift
//  LetHimCookWatchApp Watch App
//
//  Created by 길지훈 on 8/23/25.
//

import SwiftUI

struct SignalManMainView: View {
    @ObservedObject private var watchConnectivity = WatchConnectivityManager.shared
    @StateObject private var coreMotion = CoreMotionManager()
    
    var body: some View {
        // connectionState 값에 따라 뷰를 전환합니다.
        switch watchConnectivity.connectionState {
        case .loading:
            loadingView()
        case .connected:
            connectedView()
        case .disconnected:
            waitingConnectionView()
        }
    }
    
    /// 로딩 중일 때 보여줄 뷰
    private func loadingView() -> some View {
        VStack(spacing: 15) {
            ProgressView() // 로딩 인디케이터 (스피너)
                .progressViewStyle(CircularProgressViewStyle())
            Text("연결 상태 확인 중...")
        }
    }
    
    private func waitingConnectionView() -> some View {
        VStack(spacing: 10) {
            Image(systemName: "person.line.dotted.person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60)
                .foregroundStyle(.blue)
            Text("신호수와 운전수가\n연결되지 않았습니다.")
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private func connectedView() -> some View {
        VStack(spacing: 12) {
            Button(action: {
                coreMotion.toggleStopSignal()
            }) {
                Text(coreMotion.isStopSignalActive ? "CANCEL STOP" : "SEND STOP")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
            }
            .tint(coreMotion.isStopSignalActive ? .gray : .red)
            .buttonStyle(.borderedProminent)
            
            Spacer()
            
            Text(coreMotion.currentGesture.rawValue)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(gestureColor())
                .padding(.top, 8)
        }
        .padding(.horizontal)
    }
    
    private func gestureColor() -> Color {
        switch coreMotion.currentGesture {
        case .up: return .blue
        case .down: return .orange
        case .stop: return .red
        case .none: return .secondary
        }
    }
}

#Preview {
    SignalManMainView()
}
