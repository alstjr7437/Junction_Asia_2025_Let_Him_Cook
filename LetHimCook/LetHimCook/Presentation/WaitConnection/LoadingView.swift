//
//  WaitConnectionView.swift
//  LetHimCook
//
//  Created by 김민석 on 8/23/25.
//

import SwiftUI

struct WaitConnectionView: View {
    let car: Car
    
    var body: some View {
        Text(car.name)
    }
}

#Preview {
    WaitConnectionView(car: DummyData.cars[0])
}
