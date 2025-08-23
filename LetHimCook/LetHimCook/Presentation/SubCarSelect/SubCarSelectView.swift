//
//  SubCarSelectView.swift
//  LetHimCook
//
//  Created by 김민석 on 8/23/25.
//

import SwiftUI

struct SubCarSelectView: View {
    
    let majorCar: MajorCar
    @State private var alert: Bool = false
    @State private var selectedCar: Car?
    
    @EnvironmentObject var router: NavigationRouter
    
    // 해당 Major만 필터
    private var cars: [Car] {
        DummyData.carsByMajor[majorCar] ?? []
    }

    var body: some View {
        List(cars, id: \.id) { car in
            CarRow(car: car)
                .contentShape(Rectangle())
                .onTapGesture {
                    alert = true
                    selectedCar = car
                }
        }
        .navigationTitle(majorCar.displayName)
        .listStyle(.plain)
        .background(Color.white)
        .scrollContentBackground(.hidden)
        .padding(.top, 10)
        .alert(
            "Are you sure you want to select \(selectedCar?.model ?? "No Car")",
            isPresented: $alert
        ) {
            Button("Cancel", role: .cancel) {
                alert = false
                selectedCar = nil
            }
            Button("OK", role: .destructive) {
                if let car = selectedCar {
                    router.push(to: .waitConnection(car: car))
                }
            }
        } message: {
            Text("This equipment will be connected.")
        }
    }
}

private struct CarRow: View {
    let car: Car
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(car.name)
                    .font(.h3)
                Text(car.model)
                    .font(.h4)
                    .foregroundColor(.netural500)
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
