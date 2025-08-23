//
//  WatchConnectivityManager.swift
//  LetHimCook
//
//  Created by 김민석 on 8/23/25.
//

import WatchConnectivity
import Foundation

final class WatchConnectivityManager: NSObject, ObservableObject {
    static let shared = WatchConnectivityManager()
    
    private override init() {
        super.init()
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    func sendMCPConnected(_ isConnected: Bool) {
        guard WCSession.default.isReachable else {
            print("Watch is not reachable")
            return
        }
        
        let message = ["mcpConnected": isConnected]
        WCSession.default.sendMessage(message, replyHandler: nil) { error in
            print("Error sending message: \(error.localizedDescription)")
        }
    }
}

extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WC Session activation failed: \(error.localizedDescription)")
        } else {
            print("WC Session activated successfully")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WC Session became inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("WC Session deactivated")
        WCSession.default.activate()
    }
}
