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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Button("hello") {
            router.push(to: .driverMain)
        }
    }
}


#Preview {
    OnboardingView()
}
