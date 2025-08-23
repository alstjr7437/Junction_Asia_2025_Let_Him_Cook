//
//  Car.swift
//  LetHimCook
//
//  Created by 김민석 on 8/23/25.
//

struct Car {
    let major: MajorCar
    let name: String
    let width: Int
    let height: Int
}

enum MajorCar: String, CaseIterable {
    case crane
    case bulldozer
    case excavator
    case forklift
    case scraper
    
    var displayName: String {
        switch self {
        case .crane:
            return "크레인"
        case .bulldozer:
            return "불도저"
        case .excavator:
            return "굴삭기"
        case .forklift:
            return "지게차"
        case .scraper:
            return "스크레이퍼"
        }
    }
}
