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
        // 크레인
        Car(major: .crane, name: "현대 크레인 A", model: "HX-250", width: 250, height: 600),
        Car(major: .crane, name: "크레인 B", model: "HX-260", width: 260, height: 610),
        Car(major: .crane, name: "크레인 C", model: "HX-270", width: 270, height: 620),
        Car(major: .crane, name: "크레인 D", model: "HX-280", width: 280, height: 630),
        Car(major: .crane, name: "크레인 E", model: "HX-290", width: 290, height: 640),
        Car(major: .crane, name: "크레인 F", model: "HX-300", width: 300, height: 650),
        
        // 타워 크레인
        Car(major: .towerCrane, name: "삼성 타워 크레인 A", model: "TC-400", width: 400, height: 1500),
        Car(major: .towerCrane, name: "타워 크레인 B", model: "TC-410", width: 410, height: 1510),
        Car(major: .towerCrane, name: "타워 크레인 C", model: "TC-420", width: 420, height: 1520),
        Car(major: .towerCrane, name: "타워 크레인 D", model: "TC-430", width: 430, height: 1530),
        Car(major: .towerCrane, name: "타워 크레인 E", model: "TC-440", width: 440, height: 1540),
        Car(major: .towerCrane, name: "타워 크레인 F", model: "TC-450", width: 450, height: 1550),
        
        // 지게차
        Car(major: .forklift, name: "두산 지게차 C", model: "DF-120", width: 120, height: 220),
        
        // 덤프트럭
        Car(major: .dumpTruck, name: "볼보 덤프트럭 D", model: "VD-300", width: 300, height: 800),
        
        // 콘크리트 믹서트럭
        Car(major: .concreteMixerTruck, name: "현대 콘크리트 믹서트럭 E", model: "HM-280", width: 280, height: 700),
        
        // 불도저
        Car(major: .bulldozer, name: "CAT 불도저 F", model: "CAT-320", width: 320, height: 600),
        
        // 굴삭기
        Car(major: .excavator, name: "두산 굴삭기 G", model: "DX-310", width: 310, height: 650),
        
        // 스크레이퍼
        Car(major: .scraper, name: "Volvo 스크레이퍼 H", model: "VS-400", width: 400, height: 900)
    ]
}
