//
//  LetHimCookApp.swift
//  LetHimCook
//
//  Created by 김민석 on 8/23/25.
//

import SwiftUI

@main
struct LetHimCookApp: App {
    @StateObject var router: NavigationRouter = NavigationRouter()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.destinations) {
                OnboardingView()
            }.environmentObject(router)
        }
    }
}
