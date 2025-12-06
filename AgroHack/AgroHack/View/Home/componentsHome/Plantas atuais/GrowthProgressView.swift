//
//  GrowthProgressView.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 04/12/25.
//

import SwiftUI

struct GrowthProgressView: View {
    let steps: [StepsGrowthType]      // nomes dos estágios
    /*let dates: [String?]  */           // datas opcionais (card usa vazio)
    let current: StepsGrowthType              // estágio atual

    var body: some View {
        let currentIndex = steps.firstIndex(of: current) ?? 0

        HStack(alignment: .center, spacing: 0) {
            ForEach(steps.indices, id: \.self) { index in
                VStack(spacing: 10) {

                    // --- Data (só aparece se existir) ---
//                    if let date = dates[index], !date.isEmpty {
//                        Text(date)
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                            .frame(height: 18)
//                    } else {
//                        Spacer().frame(height: 18)
//                    }

                    // --- Linha + Bolinha ---
                    ZStack {
                        Rectangle()
                            .fill(Color(.systemGray4))
                            .frame(height: 2)
                            .offset(y: -1)

                        Circle()
                            .fill(circleColor(for: index, currentIndex: currentIndex))
                            .frame(width: 22, height: 22)
                    }
                    .frame(height: 24)

                    // --- Nome ---
                    Text("\(steps[index])")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .frame(height: 28)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    func circleColor(for index: Int, currentIndex: Int) -> Color {
        if index < currentIndex {
            return Color("colorSecondary")      // concluído
        } else if index == currentIndex {
            return Color("colorPrimal")         // atual
        } else {
            return Color(.systemGray3)          // futuro
        }
    }
}

struct GrowthProgressMiniView: View {
    let steps: [StepsGrowthType]
    let current: StepsGrowthType

    var body: some View {
        let currentIndex = steps.firstIndex(of: current) ?? 0

        HStack(spacing: 6) {
            ForEach(steps.indices, id: \.self) { index in
                Circle()
                    .fill(color(for: index, currentIndex: currentIndex))
                    .frame(width: 10, height: 10)
            }
        }
    }

    func color(for index: Int, currentIndex: Int) -> Color {
        if index < currentIndex {
            return Color("colorSecondary")   // já concluído
        } else if index == currentIndex {
            return Color("colorPrimal")      // atual
        } else {
            return Color(.systemGray3)       // futuro
        }
    }
}
