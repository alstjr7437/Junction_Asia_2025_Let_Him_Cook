//
//  OnboardingView.swift
//  LetHimCook
//
//  Created by 김민석 on 8/23/25.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var router: NavigationRouter
    @State private var isOperatorPressed = false
    @State private var isSignalmanPressed = false
    
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
                VStack {
                    Image(isOperatorPressed ? "operator_tapped" : "operator")
                    Text("Operator")
                        .font(.b4)
                }
                .frame(width: 361, height: 245)
                .foregroundStyle(isOperatorPressed ? .white : .black)
                .background(isOperatorPressed ? .blue : Color(#colorLiteral(red: 0.9025448561, green: 0.9424672723, blue: 0.9632663131, alpha: 1)))
                .cornerRadius(20)
                .scaleEffect(isOperatorPressed ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isOperatorPressed)
                .onTapGesture {
                    router.push(to: .majorCarSelect)
                }
                .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) {
                    // 길게 누르기 완료 (실제로는 즉시 실행됨)
                } onPressingChanged: { pressing in
                    isOperatorPressed = pressing
                }
                
                VStack {
                    Image(isSignalmanPressed ? "signalman_tapped" : "signalman")
                    Text("Signalman")
                        .font(.b4)
                }
                .frame(width: 361, height: 245)
                .foregroundStyle(isSignalmanPressed ? .white : .black)
                .background(isSignalmanPressed ? .blue : Color(#colorLiteral(red: 0.9025448561, green: 0.9424672723, blue: 0.9632663131, alpha: 1)))
                .cornerRadius(20)
                .scaleEffect(isSignalmanPressed ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isSignalmanPressed)
                .onTapGesture {
                    router.push(to: .searchDriver)
                }
                .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) {
                    // 길게 누르기 완료 (실제로는 즉시 실행됨)
                } onPressingChanged: { pressing in
                    isSignalmanPressed = pressing
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
