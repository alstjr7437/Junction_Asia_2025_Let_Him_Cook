//
//  SubCarSelectView.swift
//  LetHimCook
//
//  Created by 김민석 on 8/23/25.
//

import SwiftUI

struct SubCarSelectView: View {
    
    let majorCar: MajorCar
    
    @EnvironmentObject var router: NavigationRouter
    
    // 해당 Major만 필터
    private var cars: [Car] {
        DummyData.carsByMajor[majorCar] ?? []
    }

    var body: some View {
        List(cars, id: \.name) { car in
            CarRow(car: car)
                .contentShape(Rectangle())
                .onTapGesture {
                    router.push(to: .waitConnection(car: car))
                }
        }
        .navigationTitle(majorCar.displayName)
        .listStyle(.insetGrouped)
    }
}

private struct CarRow: View {
    let car: Car
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(car.name)
                    .font(.headline)
                Text(car.model)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    NavigationStack {
        SubCarSelectView(majorCar: .crane)
    }
}
