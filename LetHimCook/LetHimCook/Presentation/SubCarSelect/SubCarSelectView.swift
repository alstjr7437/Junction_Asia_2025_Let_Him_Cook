//
//  SubCarSelectView.swift
//  LetHimCook
//
//  Created by 김민석 on 8/23/25.
//

import SwiftUI

struct SubCarSelectView: View {
    let majorCar: MajorCar
    
    var body: some View {
        Text(majorCar.displayName)
    }
}

#Preview {
    SubCarSelectView(majorCar: .crane)
}
