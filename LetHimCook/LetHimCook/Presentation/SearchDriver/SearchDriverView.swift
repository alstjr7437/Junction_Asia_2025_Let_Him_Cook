//
//  SearchDriverView.swift
//  LetHimCook
//
//  Created by 김민석 on 8/23/25.
//

import SwiftUI

struct SearchDriverView: View {
    @StateObject var multipeerSession = MultipeerSession()
    @State private var selectedPeer: Peer? = nil

    var body: some View {
        VStack {
            PeerView(peers: multipeerSession.foundPeers) { peer in
                selectedPeer = peer
            }
        }
        .alert(item: $selectedPeer) { peer in
            Alert(
                title: Text("작업 요청 보낼까요?"),
                message: Text("\(peer.displayName)"),
                primaryButton: .destructive(Text("취소")) {
                    print("취소 선택 - \(peer.displayName)")
                },
                secondaryButton: .default(Text("승인")) {
                    multipeerSession.invite(peer)
                }
            )
        }
    }
}

#Preview {
    SearchDriverView()
}
