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
    
    init(id: UUID, name: String, image: Data? = nil) {
        self.id = id
        self.name = name
        self.image = image
    }
}
