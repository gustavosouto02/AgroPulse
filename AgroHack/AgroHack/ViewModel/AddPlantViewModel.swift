//
//  AddPlantViewModel.swift
//  AgroHack
//
//  Created by Filipi Romão on 05/12/25.
//

import Combine
import Foundation
import SwiftData

class AddPlantViewModel: ObservableObject {
    @Published var name = ""
    @Published var image: Data?
    @Published var cultura: String = ""
    @Published var solo: String = ""
    @Published var area: String = ""
    @Published var estagio: StepsGrowthType = .Inicial
    @Published var fertlizantes: String = ""
    @Published var irrigacao: String = ""
    @Published var clima: String = ""
    @Published var praga: String = ""
    
    //Ciclo de vida
    @Published var tempoCicloDeVida: Date = Date()
    @Published var dataGerminacao: Date = Date()
    @Published var dataColheita: Date = Date()
    
    @Published var temPraga:Bool = false
    @Published var usaFertilizante:Bool = false

    func salvar(context: ModelContext) {
        if let image{
            let plant = PlantModel(id: UUID(), name: name,image: image ,cultura: cultura, solo: solo, clima: clima, area: area, estagio: estagio, fertilizantes: fertlizantes, irrigacao: irrigacao, tipoPraga: praga)
            context.insert(plant)
            print("Valores salvos: \(plant.name)")
            try? context.save()
            print("Valores salvos dps do bloco try?: \(plant.name)")
            
        }
        
    }
}
