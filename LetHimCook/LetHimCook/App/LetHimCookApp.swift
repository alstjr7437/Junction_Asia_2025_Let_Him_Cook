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
    @StateObject var gestureOverlay: GestureOverlayManager = GestureOverlayManager.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // 기본 앱 콘텐츠
                NavigationStack(path: $router.destinations) {
                    OnboardingView()
                        .navigationDestination(for: NavigationDestination.self) { destination in
                            NavigationRoutingView(destination: destination)
                        }
                }.environmentObject(router)
                
                // 제스처 오버레이
                if gestureOverlay.currentGesture != .none {
                    gestureOverlayView()
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.3), value: gestureOverlay.currentGesture)
                        .zIndex(1000) // 최상위에 표시
                }
            }
        }
    }
    
    @ViewBuilder
    private func gestureOverlayView() -> some View {
        switch gestureOverlay.currentGesture {
        case .stop:
            StopView()
        case .boomUp:
            BoomUpView()
        case .boomDown:
            BoomDownView()
        case .none:
            EmptyView()
        }
    }
}
