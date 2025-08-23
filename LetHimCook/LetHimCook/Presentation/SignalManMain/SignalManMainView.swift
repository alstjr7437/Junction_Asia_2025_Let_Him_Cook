//
//  SignalManMainView.swift
//  LetHimCook
//
//  Created by 김민석 on 8/23/25.
//

import SwiftUI

struct SignalManMainView: View {
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var startTime: Date = Date()
    @State private var showExitAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            workingTimer()
            Spacer()
            usingAppleWatchText()
            Spacer()
            stopWorking()
            
            // 수동 연결 재시도 버튼
            Button("연결 재시도") {
                sendConnectedMCP()
            }
            .padding()
            .background(.orange)
            .cornerRadius(8)
        }
        .onAppear {
            startTimer()
            sendConnectedMCP()
        }
        .onDisappear {
            stopTimer()
        }
        .alert("작업을 완료하시겠습니까?", isPresented: $showExitAlert) {
            Button("계속 작업", role: .cancel) { }
            Button("작업 완료", role: .destructive) {
                stopTimer()
            }
        } message: {
            Text("현재 작업을 마치고 기록을 저장합니다.")
        }
    }
    
    /// 시간 표시
    private func workingTimer() -> some View {
        Text(timeString(from: elapsedTime))
            .font(.system(size: 90, weight: .bold, design: .monospaced))
            .padding(.top, 40)
    }
    
    /// 애플워치 사용 표시
    private func usingAppleWatchText() -> some View {
        VStack(spacing: 20) {
            Image(systemName: "lock.open.applewatch")
                .resizable()
                .scaledToFit()
                .frame(width: 70)
                .foregroundStyle(.secondary)
            
            Text("휴대폰을 주머니에 넣고")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            
            Text("애플워치를 확인해주세요")
                .font(.largeTitle)
                .foregroundColor(.secondary)
        }
    }
    
    /// 작업 종료 버튼
    private func stopWorking() -> some View {
        Button(action: {
            showExitAlert = true
        }) {
            Text("작업 종료")
                .font(.system(size: 70, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
        }
        .padding(.horizontal, 60)
        .padding(.vertical, 15)
    }
    
    
    /// 작업 시간 측정 시작
    private func startTimer() {
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            elapsedTime = Date().timeIntervalSince(startTime)
        }
    }
    
    /// 작업 시간 측정 종료
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// 시간 포매터
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    /// MCP 연결 완료 전송
    private func sendConnectedMCP() {
        print("📱 SignalManMainView: sendConnectedMCP() called")
        WatchConnectivityManager.shared.sendMCPConnected(true)
    }
}

#Preview {
    SignalManMainView()
}
