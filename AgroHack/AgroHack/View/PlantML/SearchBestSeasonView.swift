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
        TextField(
            "insira o codigo do IBGE",
            text: $bestSeasviewModel.codigoIBGE
        )
        .keyboardType(.decimalPad)
        TextField(
            "insira o codigo da cultura",
            value: $bestSeasviewModel.idCultura,
            format: .number
        )
        .keyboardType(.decimalPad)
        TextField(
            "insira o maximo de risco aceitavel",
            value: $bestSeasviewModel.riscoMaximo,
            format: .number
        )
        .keyboardType(.decimalPad)
        TextField("Qual seu solo", text: $bestSeasviewModel.soloAD)
        
        Menu{
            ForEach(cicleTypes, id: \.self) { cicle in
                Button("\(cicle.rawValue)"){bestSeasviewModel.cicloDoGrao = cicle}
            }
        } label: {
            HStack{
                Text("Tipo de grao: \(bestSeasviewModel.cicloDoGrao.rawValue)")
            }
        }


        Button("Buscar melhor epoca para plantio"){
            print("Vai buscar melhor epoca")
            Task{
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
