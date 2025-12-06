//
//  SoloModel.swift
//  AgroHack
//
//  Created by Filipi Romão on 06/12/25.
//

import Foundation
import SwiftData

@Model
class SoloModel: Identifiable {
    var id = UUID()
    var name: String
    var typeSolo: String
    var classificationAD: String
    
    init(name: String, typeSolo: String, classificationAD: String) {
        self.name = name
        self.typeSolo = typeSolo
        self.classificationAD = classificationAD
    }
}
