//
//  Peer.swift
//  LetHimCook
//
//  Created by 김민석 on 8/23/25.
//

import MultipeerConnectivity

struct Peer: Equatable, Identifiable {
    let id: String
    let displayName: String
    let peerID: MCPeerID?
    let role: PeerRole
    let carModel: String?
    
    init(id: String, displayName: String, peerID: MCPeerID? = nil, role: PeerRole = .undefined, carModel: String? = nil) {
        self.id = id
        self.displayName = displayName
        self.peerID = peerID
        self.role = role
        self.carModel = carModel
    }
}
