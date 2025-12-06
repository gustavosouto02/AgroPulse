//
//  SearchBestSeasonViewModel.swift
//  AgroHack
//
//  Created by Filipi Romão on 06/12/25.
//

import Combine
import Foundation

class SearchBestSeasonViewModel: ObservableObject {

    @Published var idCultura: Int = 0
    @Published var codigoIBGE: String = ""
    @Published var riscoMaximo: Int = 0
    @Published var soloAD: String = "AD1"
    @Published var cicloDoGrao:GroupCicleType = .Grupo1

    private let baseURL = "https://api.cnptia.embrapa.br/agritec/v2/zoneamento"
    private let token = "3481b3b3-e2af-3be8-986f-3fb568cde9ff"
    
    func getBestSeason() async throws -> BestSeasonModel{
        let BestSeasons = try await requestAPI()
        let filtered = BestSeasons.filter{ $0.solo == soloAD && $0.ciclo == cicloDoGrao.rawValue }
        print("vai chamar o request da API")
        print("-----------------------")
        print("Aqui está fazendo a filtragem para definir a melhor temporada")
        print(filtered)
        return filtered.first!
        
    }

    private func requestAPI() async throws -> [BestSeasonModel] {
        print("---------------")
        print("A API foi chamada")
        print("Os valores são idCultura: \(idCultura), codigoIBGE:\(codigoIBGE), risco maximo: \(riscoMaximo)")
        print("Entrou aq")
        let fullUrl = URL(
            string:
                "https://api.cnptia.embrapa.br/agritec/v2/zoneamento?idCultura=\(idCultura)&codigoIBGE=\(codigoIBGE)&risco=\(riscoMaximo)"
        )!

        var request = URLRequest(url: fullUrl)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)
        if let http = response as? HTTPURLResponse {
                print("📡 Status code recebido: \(http.statusCode)")
                if http.statusCode != 200 {
                    print("❌ Erro recebido: \(String(data: data, encoding: .utf8) ?? "")")
                    throw URLError(.badServerResponse)
                }
            }

            // 5. Decodificar JSON
            do {
                let result = try JSONDecoder().decode(BestSeasonResponse.self, from: data)
                print("✅ BestSeason retornado:", result)
                return result.data
            } catch {
                print("❌ Erro ao decodificar JSON:", error)
                throw error
            }

    }

}
