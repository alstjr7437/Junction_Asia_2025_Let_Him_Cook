//
//  ContentView.swift
//  LetHimCookWatchApp Watch App
//
//  Created by 길지훈 on 8/23/25.
//

import SwiftUI

struct SignalManMainView: View {
    @StateObject private var watchConnectivity = WatchConnectivityManager()
    
    var body: some View {
        if watchConnectivity.mcpConnected {
            connectedView()
        } else {
            waitingConnectionView()
        }
    }
    
    
    private func waitingConnectionView() -> some View {
        VStack(spacing: 10) {
            Text("Let Him Cook")
                .font(.title3)
                .bold()
            
            Spacer()
            
            Image(systemName: "person.line.dotted.person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60)
                .foregroundStyle(.blue)
            Text("신호수와 운전수가 연결되지 않았습니다.")
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private func connectedView() -> some View {
        VStack(spacing: 15) {
            Text("Let Him Cook")
                .font(.title3)
                .bold()
            
            Spacer()
            
            Circle()
                .fill(Color.green)
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "checkmark")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                )
            
            Text("연결 완료!")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.green)
            
            Text("신호 송신 준비됨")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    SignalManMainView()
}
