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
    let emojis = ["🦇", "🤖", "👻", "🦦", "🐒", "🐸", "🧸", "🐥"]
    
    @State private var peerPositions: [String: CGPoint] = [:]
    
    var body: some View {
        GeometryReader { geometry in
            renderPeerView(in: geometry)
        }
    }
    
    @ViewBuilder
    private func renderPeerView(in geometry: GeometryProxy) -> some View{
        let radius = min(geometry.size.width, geometry.size.height) / 3
        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
        var fixedPositions: [CGPoint] = (0..<9).map { _ in
            let angle = Double.random(in: 0..<(2 * .pi))
            let distance = Double.random(in: 100...150)
            let x = center.x + CGFloat(cos(angle) * distance)
            let y = center.y + CGFloat(sin(angle) * distance)
            return CGPoint(x: x, y: y)
        }.shuffled()
        
        ZStack {
            // stroke 생성
            ForEach(1..<5) { i in
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    .frame(width: radius * CGFloat(i), height: radius * CGFloat(i))
                    .position(center)
            }
            
            // 본인 생성
            PeerCircleView(name: centerLabel, emoji: centerEmoji, onTap: {})
            
            // 유저들 생성
            ForEach(peers.indices, id: \.self) { index in
                let peer = peers[index]

                if let position = peerPositions[peer.displayName] {
                    PeerCircleView(
                        name: peer.displayName,
                        emoji: emojis[index % emojis.count],
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
    let emoji: String
    let onTap: () -> Void

    var body: some View {
        VStack {
            Text(emoji).font(.largeTitle)
            Text(name).font(.caption)
        }
        .onTapGesture {
            onTap()
        }
    }
}
