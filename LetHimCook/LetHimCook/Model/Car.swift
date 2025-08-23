//
//  Car.swift
//  LetHimCook
//
//  Created by 김민석 on 8/23/25.
//

import Foundation

struct Car: Equatable, Hashable {
    let id: UUID = UUID()
    let major: MajorCar
    let name: String
    let model: String
    let width: Int
    let length: Int
}

enum MajorCar: String, CaseIterable {
    case crane
    case towerCrane
    case forklift
    case dumpTruck
    case concreteMixerTruck
    case bulldozer
    case excavator
    case scraper
    
    var displayName: String {
        switch self {
        case .crane:
            return "Crane"
        case .towerCrane:
            return "TowerCrane"
        case .forklift:
            return "Forklift"
        case .dumpTruck:
            return "Dump Truck"
        case .concreteMixerTruck:
            return "Concrete Mixer Truck"
        case .bulldozer:
            return "Bulldozer"
        case .excavator:
            return "Excavator"
        case .scraper:
            return "Scraper"
        }
    }
}
