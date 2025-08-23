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
        _multipeerSession = StateObject(wrappedValue: .init(displayName: car.model))
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack {
                Image(.operator)
                    .resizable()
                    .frame(width: 110, height: 68)
                Text(\(car.name)-\(car.model))
                    .font(Font.t1)
            }
            Spacer()
            
            VStack(spacing: 12) {
                Image(.loading)
                Text("The Signalman is selecting equipment")
                    .font(Font.h4)
            }.padding(.bottom, 70)
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
                title: Text("Do you accept the connection to \(multipeerSession.sendingFromPeer?.displayName ?? "")? "),
                message: Text("Connecting to \(car.name)"),
                // 왼쪽 = 거절(빨간색)
                primaryButton: .destructive(Text("Cancel")) {
                    showAlert = false
                },
                secondaryButton: .default(Text("OK")) {
                    multipeerSession.respondToInvite(accept: true)
                }
            )
        }
    }
}

#Preview {
    WaitConnectionView(car: DummyData.cars[0])
}
