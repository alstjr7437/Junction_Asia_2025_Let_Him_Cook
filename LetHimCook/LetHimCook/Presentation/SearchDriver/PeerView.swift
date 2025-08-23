//
//  PeerView.swift
//  LetHimCook
//
//  Created by 김민석 on 8/23/25.
//

import SwiftUI

struct PeerView: View {
    let peers: [Peer]
    let inviteAction: (Peer) -> Void
    let centerEmoji = "😊"
    let centerLabel = "Me"
    
    @State private var peerPositions: [String: CGPoint] = [:]
    
    var body: some View {
        GeometryReader { geometry in
            renderPeerView(in: geometry)
        }
    }
    
    @ViewBuilder
    private func renderPeerView(in geometry: GeometryProxy) -> some View {
        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
        let maxRadius = min(geometry.size.width, geometry.size.height) * 0.7  // 원하는 비율 조절
        var fixedPositions: [CGPoint] = (0..<9).map { _ in
            let angle = Double.random(in: 0..<(2 * .pi))
            let distance = Double.random(in: 100...150)
            let x = center.x + CGFloat(cos(angle) * distance)
            let y = center.y + CGFloat(sin(angle) * distance)
            return CGPoint(x: x, y: y)
        }.shuffled()
        
        ZStack {
            ConcentricRings(center: center, maxRadius: maxRadius, theme: .blueSafety)
            
            Circle()
                .fill(Color.primaryApp)
                .frame(width: 50, height: 50)
                .position(center)
            
            ForEach(peers.indices, id: \.self) { index in
                let peer = peers[index]
                
                if let position = peerPositions[peer.displayName] {
                    PeerCircleView(
                        name: peer.displayName,
                        onTap: {
                            inviteAction(peer)
                        }
                    )
                    .position(position)
                }
            }
        }
        .onChange(of: peers) { _, newPeers in
            for peer in newPeers where peerPositions[peer.id] == nil {
                if !fixedPositions.isEmpty {
                    peerPositions[peer.id] = fixedPositions.removeFirst()
                } else {
                    peerPositions[peer.id] = center
                }
            }
        }
    }
}

struct PeerCircleView: View {
    let name: String
    let onTap: () -> Void
    @State var selected: Bool = false
    
    var body: some View {
        VStack(spacing: 4) {
            Circle()
                .fill(Color.white)
                .frame(width: 70, height: 70)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                .overlay(
                    Circle().stroke(Color.blue, lineWidth: selected ? 2 : 0)
                )
            Text(name).font(.caption)       // 이름
            
        }
        .onTapGesture {
            onTap()
            selected = true
        }
    }
}
