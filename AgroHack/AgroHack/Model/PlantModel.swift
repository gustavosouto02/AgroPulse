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
    
    init(id: UUID, name: String, image: Data? = nil, cultura: String, solo: String, clima: String, area: String, estagio: String, fertilizantes: String, irrigacao: String) {
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
    }
}
