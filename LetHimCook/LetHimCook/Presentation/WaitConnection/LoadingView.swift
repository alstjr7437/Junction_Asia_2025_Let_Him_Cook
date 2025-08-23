//
//  WaitConnectionView.swift
//  LetHimCook
//
//  Created by 김민석 on 8/23/25.
//

import SwiftUI

struct WaitConnectionView: View {
    
    let car: Car
    
    @StateObject var multipeerSession: MultipeerSession
    @EnvironmentObject var router: NavigationRouter
    
    @State private var showAlert = false
    
    init(car: Car) {
        self.car = car
        _multipeerSession = StateObject(wrappedValue: .init(displayName: car.name))
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(2) // 크기 키우기
            
            Text("Waiting for signalman connection...")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top, 8)
            
            Spacer()
        }
        .environmentObject(multipeerSession)
        .navigationTitle(car.name)
        
        
        .onChange(of: multipeerSession.sendingFromPeer) { _, newValue in
            if let peer = newValue, !peer.displayName.isEmpty {
                showAlert = true
            }
        }
        .onChange(of: multipeerSession.connectedPeers) { _, newValue in
            if !newValue.isEmpty {
                router.push(to: .driverMain(multipeer: multipeerSession))
            }
        }
        
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Address Received"),
                message: Text(multipeerSession.sendingFromPeer?.displayName ?? ""),
                // 왼쪽 = 거절(빨간색)
                primaryButton: .destructive(Text("Decline")) {
                    showAlert = false
                },
                secondaryButton: .default(Text("Accept")) {
                    multipeerSession.respondToInvite(accept: true)
                }
            )
        }
    }
}

#Preview {
    WaitConnectionView(car: DummyData.cars[0])
}
