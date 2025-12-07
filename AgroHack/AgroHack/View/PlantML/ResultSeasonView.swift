//
//  ResultSeasonView.swift
//  AgroHack
//
//  Created by Filipi Romão on 07/12/25.
//

import SwiftUI

struct ResultSeasonView: View {
    @ObservedObject var bestSeasonviewModel: SearchBestSeasonViewModel
    @State var bestSeasons: [BestSeasonModel] = []
    @State var bestSeason: BestSeasonModel?
    var body: some View {
        VStack{
            Text("Dia inicio da cultura\(bestSeasonviewModel.diaIni)")
            Text("Mes iniico da cultura\(bestSeasonviewModel.mesIni)")
            Text("Dia fim da cultura\(bestSeasonviewModel.diaFim)")
            Text("Mes fim da cultura\(bestSeasonviewModel.mesFim)")
            
            VStack{
                Text("Essa foi a época que tem mais chances de obter sucesso na plantação com base nas informações do seu local e da sua cultura escolhida")
                Text("Com base na: \(bestSeasonviewModel.portaria)")
            }
        }
            .onAppear {
                Task {
                    do {
                        bestSeason = try await bestSeasonviewModel.getBestSeason()
                    } catch {
                        print("Erro ao buscar melhor safra:", error)
                    }
                }
            }
    }

}
