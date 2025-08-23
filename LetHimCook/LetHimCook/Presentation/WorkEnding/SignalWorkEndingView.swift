//
//  SignalWorkEndingView.swift
//  LetHimCook
//
//  Created by 길지훈 on 8/24/25.
//

import SwiftUI

struct SignalWorkEndingView: View {
    @EnvironmentObject var router: NavigationRouter
    
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
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    router.popToRootView()
                }
            }
        }
    }
    
    private func endWorkTitle() -> some View {
        Text("Task\n Complete.")
            .font(.system(size: 36, weight: .bold))
            .multilineTextAlignment(.center)
            .lineSpacing(1.4)
    }
    
    private func wholeWorkingTime() -> some View {
        Text("Total hours spent: 2h 30m")
            .font(Font.h2)
            .multilineTextAlignment(.center)
            .padding(.top, 30)
    }
    
    private func endWorkMent() -> some View {
        Text("Thank you for your Service.")
            .font(Font.h1)
            .multilineTextAlignment(.center)
            .lineSpacing(1.4)
            .padding(.top, 110)
    }
}

#Preview {
    SignalWorkEndingView()
}
