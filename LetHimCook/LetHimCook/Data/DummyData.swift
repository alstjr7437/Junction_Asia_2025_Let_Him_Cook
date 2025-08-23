//
//  DummyData.swift
//  LetHimCook
//
//  Created by 김민석 on 8/24/25.
//

struct DummyData {
    static let carsByMajor: [MajorCar: [Car]] = {
        Dictionary(grouping: cars, by: { $0.major })
    }()
    
    static let cars: [Car] = [
        // Crane
        Car(major: .crane, name: "Crawler Crane", model: "LR 1500", width: 9100, length: 14500),
        Car(major: .crane, name: "Crawler Crane", model: "LR 1700-1.0", width: 10700, length: 16292),
        Car(major: .crane, name: "Crawler Crane", model: "LR 1800-1.0", width: 11000, length: 17910),
        Car(major: .crane, name: "Crawler Crane", model: "LR 11000", width: 11200, length: 18530),
        Car(major: .crane, name: "Crawler Crane", model: "LR 11350", width: 13000, length: 20429),
        Car(major: .crane, name: "Crawler Crane", model: "LR 12500-1.0", width: 14900, length: 26425),
        Car(major: .crane, name: "Crawler Crane", model: "LR 13000", width: 16400, length: 27190),
        Car(major: .crane, name: "Truck Crane", model: "LTF 1045-4.1", width: 2550, length: 13379),
        Car(major: .crane, name: "Truck Crane", model: "LTF 1060-4.1", width: 2550, length: 11350),
        Car(major: .crane, name: "Hyundai Crane A", model: "HX-250", width: 250, length: 600),
        Car(major: .crane, name: "Crane B", model: "HX-260", width: 260, length: 610),
        Car(major: .crane, name: "Crane C", model: "HX-270", width: 270, length: 620),
        Car(major: .crane, name: "Crane D", model: "HX-280", width: 280, length: 630),
        Car(major: .crane, name: "Crane E", model: "HX-290", width: 290, length: 640),
        Car(major: .crane, name: "Crane F", model: "HX-300", width: 300, length: 650),
        
        // Tower Crane
        Car(major: .towerCrane, name: "Mobile Tower Crane", model: "MK 73-3.1", width: 2750, length: 13809),
        Car(major: .towerCrane, name: "Mobile Tower Crane", model: "MK 88-4.1", width: 2750, length: 15942),
        Car(major: .towerCrane, name: "Mobile Tower Crane", model: "MK 120-5.1", width: 3000, length: 15970),
        Car(major: .towerCrane, name: "Mobile Tower Crane", model: "MK 140-5.1", width: 3000, length: 15970),
        Car(major: .towerCrane, name: "Samsung Tower Crane A", model: "TC-400", width: 400, length: 1500),
        Car(major: .towerCrane, name: "Tower Crane B", model: "TC-410", width: 410, length: 1510),
        Car(major: .towerCrane, name: "Tower Crane C", model: "TC-420", width: 420, length: 1520),
        Car(major: .towerCrane, name: "Tower Crane D", model: "TC-430", width: 430, length: 1530),
        Car(major: .towerCrane, name: "Tower Crane E", model: "TC-440", width: 440, length: 1540),
        Car(major: .towerCrane, name: "Tower Crane F", model: "TC-450", width: 450, length: 1550),
        
        // Forklift
        Car(major: .forklift, name: "Doosan Forklift C", model: "DF-120", width: 120, length: 220),
        
        // Dump Truck
        Car(major: .dumpTruck, name: "Volvo Dump Truck D", model: "VD-300", width: 300, length: 800),
        
        // Concrete Mixer Truck
        Car(major: .concreteMixerTruck, name: "Hyundai Concrete Mixer Truck E", model: "HM-280", width: 280, length: 700),
        
        // Bulldozer
        Car(major: .bulldozer, name: "CAT Bulldozer F", model: "CAT-320", width: 320, length: 600),
        
        // Excavator
        Car(major: .excavator, name: "Doosan Excavator G", model: "DX-310", width: 310, length: 650),
        
        // Scraper
        Car(major: .scraper, name: "Volvo Scraper H", model: "VS-400", width: 400, length: 900)
    ]
}
