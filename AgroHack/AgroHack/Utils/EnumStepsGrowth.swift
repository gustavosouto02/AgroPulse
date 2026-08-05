//
//  EnumStepsGrowth.swift
//  AgroPulse
//
//  Created by Filipi Romão on 05/12/25.
//

import Foundation

public enum StepsGrowthType: String, CaseIterable, Codable, Hashable{
    case Inicial = "Inicial"
    case Crescimento = "Crescimento"
    case Floracao = "Floração"
    case Colheita = "Colheita"
}
