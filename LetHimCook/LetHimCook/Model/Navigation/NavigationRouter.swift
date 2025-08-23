//
//  NavigationRouter.swift
//  LetHimCook
//
//  Created by 김민석 on 8/23/25.
//

import Foundation

final class NavigationRouter: ObservableObject {
    @Published var destinations: [NavigationDestination]
    
    init(destinations: [NavigationDestination] = []) {
        self.destinations = destinations
    }
    
    func push(to view: NavigationDestination) {
        destinations.append(view)
    }
    
    func pop() {
        _ = destinations.popLast()
    }
    
    func popToRootView() {
        destinations = []
    }
}
