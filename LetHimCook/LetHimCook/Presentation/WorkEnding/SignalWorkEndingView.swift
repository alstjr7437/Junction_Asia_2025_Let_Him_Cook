//
//  SignalWorkEndingView.swift
//  LetHimCook
//
//  Created by 길지훈 on 8/24/25.
//

import SwiftUI

struct SignalWorkEndingView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .background(.black)
                .opacity(0.5)
            
            VStack(spacing: 0) {
                endWorkTitle()
                wholeWorkingTime()
                endWorkMent()
            }
            .foregroundStyle(.white)
        }
    }
    
    private func endWorkTitle() -> some View {
        Text("작업이\n 종료되었습니다.")
            .font(.system(size: 36, weight: .bold))
            .multilineTextAlignment(.center)
            .lineSpacing(1.4)
    }
    
    private func wholeWorkingTime() -> some View {
        Text("총 작업 시간: 2h 30m")
            .font(.system(size: 24, weight: .medium))
            .multilineTextAlignment(.center)
            .padding(.top, 30)
    }
    
    private func endWorkMent() -> some View {
        Text("Thank you for your Service.")
            .font(.system(size: 28, weight: .semibold))
            .multilineTextAlignment(.center)
            .lineSpacing(1.4)
            .padding(.top, 110)
    }
}

#Preview {
    SignalWorkEndingView()
}
