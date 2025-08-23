//
//  WorkEndingView.swift
//  LetHimCookWatchApp Watch App
//
//  Created by 길지훈 on 8/24/25.
//

import SwiftUI

struct WorkEndingView: View {
    var body: some View {
        waitingConnectionView()
    }
    
    private func waitingConnectionView() -> some View {
        VStack(spacing: 10) {
            Text("Let Him Cook")
                .font(.title3)
                .bold()
            
            Image(systemName: "checkmark.seal.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60)
                .foregroundStyle(.blue)
                .padding(.top, 10)
            
            Text("작업이 종료되었습니다.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            
            Button {
                
            } label: {
                Text("OK")
            }
        }
    }
}

#Preview {
    WorkEndingView()
}
