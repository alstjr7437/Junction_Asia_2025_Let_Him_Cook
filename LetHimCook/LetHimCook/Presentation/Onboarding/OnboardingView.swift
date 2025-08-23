//
//  OnboardingView.swift
//  LetHimCook
//
//  Created by 김민석 on 8/23/25.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        VStack {
            Button {
                router.push(to: .majorCarSelect)
            } label: {
                Text("운전자")
                    .frame(width: 300, height: 125)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(8)
            }
            
            Button {
                router.push(to: .searchDriver)
            } label: {
                Text("신호수")
                    .frame(width: 300, height: 125)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(8)
                
            }
        }
        .padding()
        .navigationBarItems(trailing:
            Button{
                router.push(to: .record)
            } label:{
                Text("log")
            }
        )
    }
}


#Preview {
    OnboardingView()
}
