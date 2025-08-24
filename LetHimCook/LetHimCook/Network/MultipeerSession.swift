//
//  MultipeerSession.swift
//  LetHimCook
//
//  Created by 김민석 on 8/23/25.
//

import MultipeerConnectivity
import NearbyInteraction
import os

final class MultipeerSession: NSObject, ObservableObject {
    private let serviceType = "lethimcook"
    private let session: MCSession
    private let log = Logger()
    
    private var serviceAdvertiser: MCNearbyServiceAdvertiser?
    private var serviceBrowser: MCNearbyServiceBrowser?

    let myPeerId: MCPeerID
    
    @Published var foundPeers: [Peer] = []
    @Published var connectedPeers: [MCPeerID] = []
    @Published var sendingFromPeer: Peer?
    
    @Published var nbiManager: NearbyInteractionManager?
    
    private var pendingInvitationHandler: ((Bool, MCSession?) -> Void)?
    private var pendingPeerDiscoveryTokenData: Data?
    
    // MARK: init
    init(displayName: String) {
        self.myPeerId = MCPeerID(displayName: displayName)
        self.session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
        super.init()
        self.session.delegate = self
        log.info("🔄 MultipeerSession initialized for \(self.myPeerId.displayName)")
    }
    
    deinit {
        stopDiscovery()
        log.info("🛑 MultipeerSession deinitialized")
    }
    
    // MARK: - Public Methods
    
    func startAdvertising(role: PeerRole, carModel: String? = nil) {
        stopDiscovery()
        
        let discoveryInfo = DiscoveryInfo(role: role, carModel: carModel)
        var discoveryDict: [String: String]? = nil
        if let discoveryInfoData = try? JSONEncoder().encode(discoveryInfo) {
            discoveryDict = ["info": discoveryInfoData.base64EncodedString()]
        }
        
        let advertiser = MCNearbyServiceAdvertiser(
            peer: myPeerId,
            discoveryInfo: discoveryDict,
            serviceType: serviceType
        )
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
        
        self.serviceAdvertiser = advertiser
        log.info("▶️ Started Advertising as \(role.rawValue)")
    }
    
    func startBrowsing() {
        stopDiscovery()
        
        let browser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        browser.delegate = self
        browser.startBrowsingForPeers()
        
        self.serviceBrowser = browser
        log.info("▶️ Started Browsing")
    }
    
    func stopDiscovery() {
        serviceAdvertiser?.stopAdvertisingPeer()
        serviceBrowser?.stopBrowsingForPeers()
        serviceAdvertiser = nil
        serviceBrowser = nil
        log.info("⏹️ Stopped Discovery")
        
        DispatchQueue.main.async {
            self.foundPeers.removeAll()
        }
    }
    
    func invite(_ peer: Peer) {
        guard let userPeer = peer.peerID else { return }
        log.info("📩 Inviting peer: \(userPeer.displayName)")
        serviceBrowser?.invitePeer(userPeer, to: session, withContext: nil, timeout: 30)
    }
    
    func respondToInvite(accept: Bool) {
        if let handler = pendingInvitationHandler {
            log.info("🟢 Responding to invite: \(accept ? "Accept" : "Decline")")
            handler(accept, session)
            pendingInvitationHandler = nil
        }
    }
    
    // MARK: - Gesture & Data Sending
    
    struct GestureCommand: Codable {
        let gesture: GestureOverlayManager.GestureType
    }

    func send(gesture: GestureOverlayManager.GestureType) {
        log.info("✉️ Sending gesture: \(gesture.rawValue)")
        guard !session.connectedPeers.isEmpty else {
            log.warning("⚠️ No connected peers to send gesture to.")
            return
        }

        let command = GestureCommand(gesture: gesture)
        do {
            let data = try JSONEncoder().encode(command)
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            log.info("✅ Gesture sent successfully.")
        } catch {
            log.error("❌ Failed to send gesture: \(error.localizedDescription)")
        }
    }
    
    // MARK: - NBI Attachment
    
    func attachNearbyInteraction() {
        guard nbiManager == nil else { return }

        let sender: (Data) -> Void = { [weak self] data in
            guard let self, !self.session.connectedPeers.isEmpty else { return }
            do {
                try self.session.send(data, toPeers: self.session.connectedPeers, with: .reliable)
            } catch {
                self.log.error("❌ NBI data send failed: \(error.localizedDescription)")
            }
        }

        let manager = NearbyInteractionManager(sendData: sender)
        self.nbiManager = manager
        log.info("🔗 NearbyInteraction attached.")

        if let tokenData = pendingPeerDiscoveryTokenData {
            log.info("➡️ Flushing pending peer token.")
            manager.receivePeerDiscoveryToken(tokenData)
            pendingPeerDiscoveryTokenData = nil
        }
    }
    
    // MARK: - Private Helpers
    
    private func peer(for peerID: MCPeerID, with info: [String: String]?) -> Peer {
        var peerRole = PeerRole.undefined
        var peerCarModel: String? = nil
        
        if let infoDataString = info?["info"],
           let infoData = Data(base64Encoded: infoDataString),
           let discoveryInfo = try? JSONDecoder().decode(DiscoveryInfo.self, from: infoData) {
            peerRole = discoveryInfo.role
            peerCarModel = discoveryInfo.carModel
            log.info("ℹ️ Decoded discovery info for \(peerID.displayName): Role \(peerRole.rawValue), Car \(peerCarModel ?? "N/A")")
        }
        
        return Peer(
            id: peerID.displayName,
            displayName: peerID.displayName,
            peerID: peerID,
            role: peerRole,
            carModel: peerCarModel
        )
    }
}

// MARK: - Session Delegate
extension MultipeerSession: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        log.info("🔁 Peer state changed: \(peerID.displayName) -> \(state.rawValue)")
        DispatchQueue.main.async {
            switch state {
            case .connected:
                if !self.connectedPeers.contains(peerID) {
                    self.connectedPeers.append(peerID)
                    self.attachNearbyInteraction()
                }
            case .notConnected:
                self.connectedPeers.removeAll { $0 == peerID }
            default:
                break
            }
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        log.info("📦 Received data: \(data.count) bytes from \(peerID.displayName)")

        if let command = try? JSONDecoder().decode(GestureCommand.self, from: data) {
            log.info("✅ Gesture received: \(command.gesture.rawValue)")
            DispatchQueue.main.async {
                GestureOverlayManager.shared.showGesture(command.gesture)
            }
            return
        }

        if let (type, payload) = NearbyInteractionManager.unwrap(data) {
            switch type {
            case .nbiToken:
                if let mgr = self.nbiManager {
                    log.info("🔑 Peer token received (live). Passing to NBI.")
                    DispatchQueue.main.async { mgr.receivePeerDiscoveryToken(payload) }
                } else {
                    log.info("🧳 Peer token received before NBI attached. Buffering.")
                    self.pendingPeerDiscoveryTokenData = payload
                }
            }
            return
        }
        
        log.warning("⚠️ Received unknown data format.")
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        log.info("InputStream received, but not handled.")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        log.info("Started receiving resource, but not handled.")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {
        if let error = error {
            log.error("❌ Error receiving resource: \(error.localizedDescription)")
        }
    }
}

// MARK: - Advertiser Delegate
extension MultipeerSession: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: any Error) {
        log.error("❌ Failed to start advertising: \(error.localizedDescription)")
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        log.info("📥 Invitation received from \(peerID.displayName)")
        DispatchQueue.main.async {
            self.sendingFromPeer = self.peer(for: peerID, with: nil) // Context is not used here for info
            self.pendingInvitationHandler = invitationHandler
        }
    }
}

// MARK: - Browser Delegate
extension MultipeerSession: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: any Error) {
        log.error("❌ Failed to start browsing: \(error.localizedDescription)")
    }

    func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String: String]?) {
        let newPeer = peer(for: peerID, with: info)
        DispatchQueue.main.async {
            if !self.foundPeers.contains(where: { $0.id == newPeer.id }) {
                self.foundPeers.append(newPeer)
                self.log.info("🔍 Found peer: \(newPeer.displayName) with role \(newPeer.role.rawValue)")
            }
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        log.info("⚠️ Lost peer: \(peerID.displayName)")
        DispatchQueue.main.async {
            self.foundPeers.removeAll { $0.id == peerID.displayName }
        }
    }
}

// MARK: - PeerID Identifiable
extension MCPeerID: @retroactive Identifiable {
    public var id: String { displayName }
}
