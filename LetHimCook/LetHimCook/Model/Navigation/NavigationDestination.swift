//
//  NavigationDestination.swift
//  LetHimCook
//
//  Created by 김민석 on 8/23/25.
//

enum NavigationDestination: Hashable {
    // 신호수 연결 화면
    case searchDriver
    
    // 운전수 연결 화면
    case majorCarSelect
    case subCarSelect(majorCar: MajorCar)
    
    // 로딩
    case waitConnection(car: Car)
    case record
    
    // 메인
    case signalManMain
    case driverMain(multipeer: MultipeerSession)
    
    case workingEnding
}
