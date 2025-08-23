//
//  NavigationView.swift
//  LetHimCook
//
//  Created by 김민석 on 8/23/25.
//

import SwiftUI

struct NavigationRoutingView: View {
    
    @State var destination: NavigationDestination
    
    var body: some View {
        Group {
            switch destination {
            case .searchDriver:
                SearchDriverView()
                
            case .majorCarSelect:
                MajorCarSelectView()
            case .subCarSelect(let majorCar):
                SubCarSelectView(majorCar: majorCar)
                
            case .waitConnection(let car):
                WaitConnectionView(car: car)
            case .record:
                RecordView()
                
            case .signalManMain:
                SignalManMainView()
            case .driverMain(let multipeer):
                DriverMainView(multipeer: multipeer)
                
            case .workingEnding:
                SignalWorkEndingView()
            }
        }
    }
}
