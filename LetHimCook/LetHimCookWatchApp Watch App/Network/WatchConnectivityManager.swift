//
//  WatchConnectivityManager.swift
//  LetHimCookWatchApp (Watch)
//
//  Created by 길지훈 on 8/23/25.
//

import WatchConnectivity
import Foundation

// ❗️이 파일은 Watch App 프로젝트 타겟에만 포함되어야 합니다.

// ❌ final class WatchConnectivityManager: ObservableObject
// ✅ NSObject를 상속받도록 수정해야 합니다.
final class WatchConnectivityManager: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = WatchConnectivityManager()
    
    enum ConnectionState {
        case loading
        case connected
        case disconnected
    }
    
    @Published var connectionState: ConnectionState = .loading
    
    private let session: WCSession
    
    // NSObject를 상속받았으므로, init은 override가 되어야 합니다.
    private override init() {
        self.session = .default
        super.init()
        session.delegate = self
        session.activate()
    }
    
    // ✅ 이제 이 메서드들은 WCSessionDelegate의 요구사항을 정상적으로 만족합니다.
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            print("✅ Watch WC Session activated successfully.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                if self.connectionState == .loading {
                    self.connectionState = .disconnected
                }
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        handleReceivedMessage(message)
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        handleReceivedMessage(applicationContext)
    }
    
    private func handleReceivedMessage(_ message: [String: Any]) {
        if let isConnected = message["mcpConnected"] as? Bool {
            DispatchQueue.main.async {
                self.connectionState = isConnected ? .connected : .disconnected
            }
        }
    }
    
    /// 제스처를 iPhone으로 전송
    func sendGesture(_ gestureType: String) {
        let message = ["gesture": gestureType]
        
        if session.isReachable {
            session.sendMessage(message, replyHandler: nil) { error in
                // 즉시 전송 실패 시 Application Context 사용
                self.sendGestureViaContext(gestureType)
            }
        } else {
            // 워치가 즉시 연결되지 않은 경우 Application Context 사용
            sendGestureViaContext(gestureType)
        }
    }
    
    private func sendGestureViaContext(_ gestureType: String) {
        let context = ["gesture": gestureType, "timestamp": Date().timeIntervalSince1970] as [String : Any]
        
        do {
            try session.updateApplicationContext(context)
        } catch {
            // 실패 시 무시
        }
    }
}
