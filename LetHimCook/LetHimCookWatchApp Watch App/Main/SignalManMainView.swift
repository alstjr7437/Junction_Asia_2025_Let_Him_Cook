//
//  SignalManMainView.swift
//  LetHimCookWatchApp Watch App
//
//  Created by 길지훈 on 8/23/25.
//

import SwiftUI

struct SignalManMainView: View {
    @StateObject private var watchConnectivity = WatchConnectivityManager()
    @StateObject private var coreMotion = CoreMotionManager()
    
    var body: some View {
        // TODO: - 실제 연결 상태에 맞게 주석을 해제하거나 수정하세요.
        // if watchConnectivity.mcpConnected {
        //     connectedView()
        // } else {
        //     waitingConnectionView()
        // }
        
        // --- 테스트를 위해 항상 connectedView()를 보여주도록 임시 수정 ---
        connectedView()
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
            
            // '정지' 신호를 보내거나 취소하는 버튼
            // AssistiveTouch는 이 버튼을 '탭'하여 제어합니다.
            Button(action: {
                // 버튼을 누르면 매니저의 토글 메서드를 호출합니다.
                coreMotion.toggleStopSignal()
            }) {
                // coreMotion.isStopSignalActive 상태에 따라 버튼의 텍스트를 변경합니다.
                Text(coreMotion.isStopSignalActive ? "CANCEL STOP" : "SEND STOP")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
            }
            // 상태에 따라 버튼의 색상도 변경합니다.
            .tint(coreMotion.isStopSignalActive ? .gray : .red)
            .buttonStyle(.borderedProminent)
            .accessibilityLabel(coreMotion.isStopSignalActive ? "정지 신호 취소" : "정지 신호 보내기")
            
            Spacer()
            
            // 현재 제스처 표시
            Text(coreMotion.currentGesture.rawValue)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(gestureColor())
                .padding(.top, 8)
        }
        .padding(.horizontal)
    }
    
    private func gestureColor() -> Color {
        switch coreMotion.currentGesture {
        case .up:
            return .blue
        case .down:
            return .orange
        case .stop:
            return .red
        case .none:
            return .secondary
        }
    }
}

#Preview {
    SignalManMainView()
}
