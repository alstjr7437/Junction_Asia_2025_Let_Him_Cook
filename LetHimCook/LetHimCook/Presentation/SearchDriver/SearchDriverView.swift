//
//  SearchDriverView.swift
//  LetHimCook
//
//  Created by 김민석 on 8/23/25.
//

import SwiftUI

struct SearchDriverView: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject var multipeerSession = MultipeerSession(displayName: "Let Him Cook")
    @State private var selectedPeer: Peer? = nil

    var body: some View {
        VStack(spacing: 28) {
            PeerView(peers: multipeerSession.foundPeers) { peer in
                selectedPeer = peer
            }
            VStack(spacing: 12) {
                Image(.loading)
                Text("Looking for a device to connect to")
                    .font(Font.h4)
            }
            Spacer()
        }
        .alert(item: $selectedPeer) { peer in
            Alert(
                title: Text("Send a pairing request?"),
                message: Text("\(peer.displayName)"),
                primaryButton: .destructive(Text("Cancel")) {
                    selectedPeer = nil
                },
                secondaryButton: .default(Text("OK")) {
                    multipeerSession.invite(peer)
                }
            )
        }
        .onChange(of: multipeerSession.connectedPeers) { _, newValue in
            if !newValue.isEmpty {
                router.push(to: .signalManMain)
            }
        }
    }
}

#Preview {
    SearchDriverView()
}
