//
//  StopView.swift
//  LetHimCook
//
//  Created by 길지훈 on 8/24/25.
//

import SwiftUI

struct StopView: View {
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(Color(#colorLiteral(red: 0.9995678067, green: 0.07505235821, blue: 0.1256510317, alpha: 1)))
                .ignoresSafeArea(edges: .all)
            
            Text("STOP")
                .font(.sb7)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    StopView()
}
