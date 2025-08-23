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
            Spacer()
            usingAppleWatchText()
            workingTimer()
            Spacer()
            stopWorking()
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
            .font(.custom("Pretendard-SemiBold", size: 56))
            .padding(.top, 40)
    }
    
    /// 애플워치 사용 표시
    private func usingAppleWatchText() -> some View {
        VStack(spacing: 20) {
            Image(systemName: "applewatch.radiowaves.left.and.right")
                .font(.system(size: 72))
                .foregroundColor(.primaryApp)
            
            Text("Pocket your phone and check your Apple Watch")
                .font(Font.t1)
                .padding(.horizontal, 50)
                .multilineTextAlignment(.center)
        }
        .frame(height: 305)
        .frame(maxWidth: .infinity)
        .background(Color.netural100)
        .cornerRadius(20)
        .padding()
    }
    
    /// 작업 종료 버튼
    private func stopWorking() -> some View {
        Button(action: {
            showExitAlert = true
        }) {
            Text("작업 종료")
                .font(Font.t1)
                .foregroundColor(.white)
                .frame(height: 71)
                .frame(maxWidth: .infinity)
                .background(.primaryApp)
                .cornerRadius(15)
        }
        .padding()
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
        WatchConnectivityManager.shared.sendMCPConnected(true)
    }
}

#Preview {
    SignalManMainView()
}
