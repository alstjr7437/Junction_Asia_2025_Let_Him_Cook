//
//  WatchConnectivityManager.swift
//  LetHimCookWatchApp Watch App
//
//  Created by 길지훈 on 8/23/25.
//

import WatchConnectivity
import Foundation

final class WatchConnectivityManager: NSObject, ObservableObject {
    @Published var mcpConnected: Bool = false
    
    override init() {
        super.init()
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
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
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let connected = message["mcpConnected"] as? Bool {
                self.mcpConnected = connected
                print("Received MCP connection status: \(connected)")
            }
        }
    }
}