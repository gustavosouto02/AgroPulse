//
//  SearchBestSeasonViewModel.swift
//  AgroHack
//
//  Created by Filipi Romão on 06/12/25.
//

import Combine
import Foundation

class SearchBestSeasonViewModel: ObservableObject {
    
    @Published var cultura: String = ""
    @Published var idCultura: Int = 0
    @Published var codigoIBGE: String = ""
    @Published var riscoMaximo: Int = 0
    @Published var tipoSolo: EnumTiposSolo = .Latossolo
    @Published var soloAD: [String] = ["AD1"]
    @Published var cicloDoGrao:GroupCicleType = .Grupo1
    
    @Published var diaIni: Int = 0
    @Published var mesIni: Int = 0
    @Published var diaFim: Int = 0
    @Published var mesFim: Int = 0
    
    @Published var portaria: String = ""
    
    var tiposSolo: [EnumTiposSolo] = EnumTiposSolo.allCases

    private let baseURL = "https://api.cnptia.embrapa.br/agritec/v2/zoneamento"
    private let token = "3481b3b3-e2af-3be8-986f-3fb568cde9ff"
    
    func getBestSeason() async throws -> BestSeasonModel{
        let BestSeasons = try await requestAPI()
        switch tipoSolo {
        case .Latossolo:
            soloAD = ["AD1", "AD2"]
        case .Litossolo:
            soloAD = ["AD3"]
        case .TerraRoxa:
            soloAD = ["AD6"]
        }
        let filtered = BestSeasons.filter { season in
            soloAD.contains(season.solo) && season.ciclo == cicloDoGrao.rawValue
        }
        if let first = filtered.first {
            diaIni = first.diaIni
            mesIni = first.mesIni
            diaFim = first.diaFim
            mesFim = first.mesFim
            portaria = first.portaria
        }
        print("vai chamar o request da API")
        print("-----------------------")
        print("Aqui está fazendo a filtragem para definir a melhor temporada")
        print(filtered)
        return filtered.first!
        
    }

    private func requestAPI() async throws -> [BestSeasonModel] {
        switch cultura{
        case "Feijão":
            idCultura = 62
        case "Soja":
            idCultura = 60
        default:
            return []
        }
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
