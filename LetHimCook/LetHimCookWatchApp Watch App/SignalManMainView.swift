//
//  ContentView.swift
//  LetHimCookWatchApp Watch App
//
//  Created by 길지훈 on 8/23/25.
//

import SwiftUI

struct SignalManMainView: View {
    var body: some View {
        waitingConnectionView()
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
    
}

#Preview {
    SignalManMainView()
}
