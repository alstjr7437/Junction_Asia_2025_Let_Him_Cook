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
            HStack {
                Text("Signalman")
                    .font(.b4)
                Spacer()
                
                Button{
                    router.push(to: .record)
                } label:{
                    Text("Log")
                        .foregroundStyle(Color(#colorLiteral(red: 0.5465203524, green: 0.5815119147, blue: 0.5980941057, alpha: 1)))
                        .font(.sb2)
                }
            }
            
            Spacer()
            
            VStack(spacing: 17) {
                Button {
                    router.push(to: .majorCarSelect)
                } label: {
                    VStack {
                        Image("operator")
                        Text("Operator")
                            .font(.b4)
                    }
                    .frame(width: 361, height: 245)
                    .foregroundStyle(.black)
                    .background(Color(#colorLiteral(red: 0.9025448561, green: 0.9424672723, blue: 0.9632663131, alpha: 1)))
                    .cornerRadius(20)
                }
                
                Button {
                    router.push(to: .searchDriver)
                } label: {
                    VStack {
                        Image("signalman")
                        Text("Signalman")
                            .font(.b4)
                    }
                    .frame(width: 361, height: 245)
                    .foregroundStyle(.black)
                    .background(Color(#colorLiteral(red: 0.9025448561, green: 0.9424672723, blue: 0.9632663131, alpha: 1)))
                    .cornerRadius(20)
                }
            }
            
            Spacer()
        }
        .padding()
    }
}


#Preview {
    OnboardingView()
}
