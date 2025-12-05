//
//  PlantModel.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 03/12/25.
//

import Foundation
import SwiftData

@Model
class PlantModel: Identifiable {
    var id: UUID = UUID()
    var name: String
    var image: Data?
    var cultura: String
    var solo: String
    var clima: String
    var area: String
    var estagio: String
    var fertilizantes: String
    var irrigacao: String
    var dataGerminacao: Date?
    var dataColheita: Date?
    
    // NOVAS DATAS
    var ultimaRega: Date?
    var ultimaAdubacao: Date?
    var ultimaPraga: Date?
    var ultimoTratamento: Date?
    
    init(id: UUID, name: String, image: Data? = nil, cultura: String, solo: String, clima: String, area: String, estagio: String, fertilizantes: String, irrigacao: String, dataGerminacao: Date? = nil, dataColheita: Date? = nil, ultimaRega: Date? = nil, ultimaAdubacao: Date? = nil, ultimaPraga: Date? = nil, ultimoTratamento: Date? = nil) {
        self.id = id
        self.name = name
        self.image = image
        self.cultura = cultura
        self.solo = solo
        self.clima = clima
        self.area = area
        self.estagio = estagio
        self.fertilizantes = fertilizantes
        self.irrigacao = irrigacao

        self.dataGerminacao = dataGerminacao
        self.dataColheita = dataColheita
        self.ultimaRega = ultimaRega
        self.ultimaAdubacao = ultimaAdubacao
        self.ultimaPraga = ultimaPraga
        self.ultimoTratamento = ultimoTratamento
    }
}

