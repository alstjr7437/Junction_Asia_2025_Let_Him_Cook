//
//  MultipeerSession.swift
//  LetHimCook
//
//  Created by 김민석 on 8/23/25.
//

import MultipeerConnectivity
import os

final class MultipeerSession: NSObject, ObservableObject {
    private let serviceType = "LetHimCook"
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser
    private let session: MCSession
    private let log = Logger()
    let myPeerId = MCPeerID(displayName: UUID().uuidString)
    var connectPeer: Peer? = nil
    
    @Published var foundPeers: [Peer] = []
    @Published var connectedPeers: [MCPeerID] = []
    @Published var sendingFromPeer: Peer?
    @Published var giverAddress: String?
    
    private var pendingInvitationHandler: ((Bool, MCSession?) -> Void)?
    
    // MARK: init
    override init() {
        session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        
        super.init()
        
        session.delegate = self
        serviceAdvertiser.delegate = self
        serviceBrowser.delegate = self
        
        serviceAdvertiser.startAdvertisingPeer()
        serviceBrowser.startBrowsingForPeers()
        
        log.info("🔄 MultipeerSession initialized for \(self.myPeerId.displayName)")
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
        log.info("🛑 MultipeerSession deinitialized")
    }
    
    // MARK: custom Method
    func invite(_ peer: Peer) {
        guard let userPeer = peer.peerID else { return }
        log.info("📩 초대 전송: \(userPeer.displayName)")
        serviceBrowser.invitePeer(userPeer, to: session, withContext: nil, timeout: 10)
    }
    
    func send() {
        log.info("✉️ send() 호출됨, 현재 연결 수: \(self.session.connectedPeers.count)")
    }

    func respondToInvite(accept: Bool, address: String) {
        if let handler = pendingInvitationHandler {
            log.info("🟢 초대 \(accept ? "수락" : "거절")")
            handler(accept, session)
            pendingInvitationHandler = nil
            
            if accept {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let data = Data(address.utf8)
                    do {
                        try self.session.send(data, toPeers: self.session.connectedPeers, with: .reliable)
                        self.log.info("📤 주소 전송 완료: \(address)")
                    } catch {
                        self.log.error("❌ 주소 전송 실패: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    private func peer(for peerID: MCPeerID) -> Peer {
        return Peer(id: peerID.displayName, displayName: peerID.displayName, peerID: peerID)
    }
}

// MARK: - Advertiser Delegate

extension MultipeerSession: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        log.error("❌ Advertiser 시작 실패: \(String(describing: error))")
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        log.info("📥 초대 수신: \(peerID.displayName)")
        DispatchQueue.main.async {
            self.pendingInvitationHandler = invitationHandler
            self.sendingFromPeer = self.peer(for: peerID)
            // 초대는 수동 수락
            // 👉 연결은 사용자가 respondToInvite()에서 수락할 때 수행
        }
    }
}

// MARK: - Browser Delegate

extension MultipeerSession: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        log.error("❌ Browser 시작 실패: \(String(describing: error))")
    }

    func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String: String]?) {
        let peer = peer(for: peerID)
        DispatchQueue.main.async {
            if !self.foundPeers.contains(where: { $0.id == peerID.displayName }) {
                self.foundPeers.append(peer)
                self.log.info("🔍 피어 발견: \(peerID.displayName)")
            }
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        log.info("⚠️ 피어 손실: \(peerID.displayName)")
        DispatchQueue.main.async {
            self.foundPeers.removeAll { $0.id == peerID.displayName }
        }
    }
}

// MARK: - Session Delegate

extension MultipeerSession: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        log.info("🔁 피어 상태 변경: \(peerID.displayName) → \(state.rawValue)")
        connectPeer = peer(for: peerID)
        DispatchQueue.main.async {
            switch state {
            case .connected:
                if !self.connectedPeers.contains(peerID) {
                    self.connectedPeers.append(peerID)
                }
            case .notConnected:
                self.connectedPeers.removeAll { $0 == peerID }
            default:
                break
            }
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        log.info("📦 데이터 수신: \(data.count) bytes from \(peerID.displayName)")
        
        guard let address = String(data: data, encoding: .utf8) else {
            log.error("❌ 받은 데이터 디코딩 실패")
            return
        }
        
        DispatchQueue.main.async {
            self.giverAddress = address
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}

// MARK: - PeerID Identifiable

extension MCPeerID: @retroactive Identifiable {
    public var id: String { displayName }
}
