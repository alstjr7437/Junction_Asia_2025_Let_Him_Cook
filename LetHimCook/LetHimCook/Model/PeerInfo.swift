//
//  PeerInfo.swift
//  LetHimCook
//
//  Created by Gemini on 8/24/25.
//

import Foundation

enum PeerRole: String, Codable {
    case driver = "운전자"
    case signalman = "신호수"
    case undefined = "미정의"
}

struct DiscoveryInfo: Codable {
    let role: PeerRole
    let carModel: String?
}
