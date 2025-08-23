//
//  MajorCarSelectView.swift
//  LetHimCook
//
//  Created by 김민석 on 8/23/25.
//

import SwiftUI

struct MajorCarSelectView: View {
    @EnvironmentObject var router: NavigationRouter

    // 2열 고정
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(MajorCar.allCases, id: \.self) { major in
                    selectMajorCarButton(major: major)
                }
            }
            .padding(.top, 60)
            .padding(16)
        }
    }

    @ViewBuilder
    func selectMajorCarButton(major: MajorCar) -> some View {
        Button {
            router.push(to: .subCarSelect(majorCar: major))
        } label: {
            Text(major.displayName)
                .font(.headline)
                .frame(maxWidth: .infinity, minHeight: 150)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.3), in: RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    MajorCarSelectView()
        .environmentObject(NavigationRouter())
}
