//
//  WatchConnectivityManager.swift
//  LetHimCook (iPhone)
//
//  Created by 김민석 on 8/23/25.
//

import WatchConnectivity
import Foundation

// ❗️이 파일은 iPhone 프로젝트 타겟에만 포함되어야 합니다.
final class WatchConnectivityManager: NSObject, WCSessionDelegate {
    static let shared = WatchConnectivityManager()
    
    private let session: WCSession
    private weak var multipeerSession: MultipeerSession?
    
    // 보낼 메시지가 여러 개일 경우를 대비해 단일 메시지 대신 '큐(Queue)'로 관리합니다.
    private var messageQueue: [[String: Any]] = []
    
    private override init() {
        self.session = .default
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func configure(with session: MultipeerSession) {
        print("🔌 WatchConnectivityManager configured with MultipeerSession.")
        self.multipeerSession = session
    }
    
    // 세션 활성화가 완료되면 호출됩니다.
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            print("✅ iPhone WC Session activated successfully.")
            // 세션이 활성화되면, 대기 중이던 모든 메시지를 순서대로 전송합니다.
            processMessageQueue()
        } else if let error = error {
            print("❌ WC Session activation failed: \(error.localizedDescription)")
        }
    }
    
    /// MPC 연결 상태를 Watch로 전송하는 함수
    func sendMCPConnected(_ isConnected: Bool) {
        let message = ["mcpConnected": isConnected]
        
        // 세션이 아직 활성화되지 않았다면, 메시지를 큐에 추가하고 기다립니다.
        guard session.activationState == .activated else {
            print("⏳ WC Session not active yet. Queuing message: \(message)")
            messageQueue.append(message)
            return
        }
        
        // 세션이 활성화되었다면 즉시 전송합니다.
        sendMessage(message)
    }
    
    /// 대기열에 있는 메시지를 처리하는 함수
    private func processMessageQueue() {
        // 큐가 비어있지 않다면
        guard !messageQueue.isEmpty else { return }
        
        print("▶️ Processing \(messageQueue.count) queued messages...")
        // 모든 메시지를 전송하고 큐를 비웁니다.
        messageQueue.forEach { sendMessage($0) }
        messageQueue.removeAll()
    }
    
    /// 실제 메시지를 전송하는 로직
    private func sendMessage(_ message: [String: Any]) {
        if session.isReachable {
            session.sendMessage(message, replyHandler: nil) { error in
                print("❌ sendMessage error: \(error.localizedDescription)")
            }
        } else {
            do {
                try session.updateApplicationContext(message)
            } catch {
                print("❌ updateApplicationContext error: \(error.localizedDescription)")
            }
        }
    }
    
    // --- 워치에서 메시지 수신 ---
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        handleReceivedGesture(from: message)
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        handleReceivedGesture(from: applicationContext)
    }
    
    private func handleReceivedGesture(from data: [String: Any]) {
        guard let gestureString = data["gesture"] as? String else { return }
        
        DispatchQueue.main.async {
            self.processGesture(gestureString)
        }
    }
    
    private func processGesture(_ gestureString: String) {
        let gestureType: GestureOverlayManager.GestureType
        
        switch gestureString {
        case "Stop":
            gestureType = .stop
        case "Up":
            gestureType = .boomUp
        case "Down":
            gestureType = .boomDown
        case "none":
            gestureType = .none
        default:
            print("⚠️ Unknown gesture string received: \(gestureString)")
            return // 알 수 없는 제스처는 무시
        }
        
        print("▶️ Watch gesture [\(gestureString)] received, forwarding to MultipeerSession...")
        multipeerSession?.send(gesture: gestureType)
    }
    
    // --- iOS 전용 델리게이트 메서드 ---
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
}
