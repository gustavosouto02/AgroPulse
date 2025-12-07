//
//  SearchBestSeasonView.swift
//  AgroHack
//
//  Created by Filipi Romão on 06/12/25.
//

import SwiftUI

struct SearchBestSeasonView: View {
    @StateObject var bestSeasviewModel = SearchBestSeasonViewModel()
    @State var bestSeasons: [BestSeasonModel] = []
    @State var bestSeason: BestSeasonModel?

    var cicleTypes: [GroupCicleType] = GroupCicleType.allCases


    var body: some View {
        VStack {
            Text("Sua melhor época")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text(
                "Entenda o período ideal para ter mais sucesso na sua plantação"
            )
            .font(.subheadline)
        }
        .padding()
        VStack {
            Text("Preencha os dados abaixo")
                .font(.title3)
                .fontWeight(.medium)
            VStack {
                TextField(
                    "insira o codigo do IBGE",
                    text: $bestSeasviewModel.codigoIBGE
                )
                .keyboardType(.decimalPad)
                Divider()
                TextField(
                    "insira o codigo da cultura",
                    value: $bestSeasviewModel.idCultura,
                    format: .number
                )
                .keyboardType(.decimalPad)
                
                Menu {
                    ForEach(bestSeasviewModel.tiposSolo, id: \.self) { solo in
                        Button("\(solo.rawValue)") {
                            bestSeasviewModel.tipoSolo = solo
                        }
                    }
                } label: {
                    HStack {
                        Text(
                            "Tipo de solo: \(bestSeasviewModel.tipoSolo.rawValue)"
                        )
                    }
                }
            }
            .padding()
            .frame(width: 363)
            .background(Color.white)
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.05), radius: 5, y: 3)
            .padding(.horizontal)

            VStack {
                Menu {
                    Button("20") {
                        bestSeasviewModel.riscoMaximo = 20
                    }
                    Button("30") {
                        bestSeasviewModel.riscoMaximo = 30
                    }
                    Button("40") {
                        bestSeasviewModel.riscoMaximo = 40
                    }
                } label: {
                    HStack {
                        Text("Risco máximo aceito")
                        Image(systemName: "chevron.up.chevron.down")
                    }
                }

                Menu {
                    ForEach(cicleTypes, id: \.self) { cicle in
                        Button("\(cicle.rawValue)") {
                            bestSeasviewModel.cicloDoGrao = cicle
                        }
                    }
                } label: {
                    HStack {
                        Text(
                            "Tipo de grao: \(bestSeasviewModel.cicloDoGrao.rawValue)"
                        )
                    }
                }
            }.padding()
                .frame(width: 363)
                .background(Color.white)
                .cornerRadius(18)
                .shadow(color: Color.black.opacity(0.05), radius: 5, y: 3)
                .padding(.horizontal)

        }

        Button("Buscar melhor epoca para plantio") {
            print("Vai buscar melhor epoca")
            Task {
                //                bestSeasons = try await bestSeasviewModel.getBestSeason()

                bestSeason = try await bestSeasviewModel.getBestSeason()
                print(bestSeason)

            }
        }

    }
}

#Preview {
    SearchBestSeasonView()
}
