//
//  Appdelegate.swift
//  LetHimCook
//
//  Created by 김민석 on 8/24/25.
//

import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        setUIAppearance()
        
        return true
    }
    
    private func setUIAppearance() {
        let navigationAppearance = UINavigationBarAppearance()
        let buttonItemAppearance = UIBarButtonItemAppearance()
        
        // Navigaton Appearance 설정
        navigationAppearance.configureWithTransparentBackground()
        navigationAppearance.backgroundColor = .white
        
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
        
        // ButtonItem Appearance 설정
        buttonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        navigationAppearance.backButtonAppearance = buttonItemAppearance
        UIBarButtonItem.appearance().tintColor = UIColor(.black)
    }
}
