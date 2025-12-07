//
//  SoilInfo.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 07/12/25.
//

import Foundation

struct SoilInfo {
    let title: String
    let description: String
    let tips: [String]
}

func getSoilInfo(for label: String) -> SoilInfo? {
    let key = label.trimmingCharacters(in: .whitespacesAndNewlines)
    return soilInfoDictionary[key]
}

let soilInfoDictionary: [String: SoilInfo] = [
    
    "Latossolo": SoilInfo(
        title: "Latossolo",
        description: "Solo profundo, bem drenado, comum no Cerrado. Geralmente ácido e pobre em nutrientes naturais.",
        tips: [
            "Aplicar calcário para corrigir acidez.",
            "Adicionar fósforo e potássio.",
            "Usar matéria orgânica para melhorar a fertilidade."
        ]
    ),
    
    "Terra Roxa": SoilInfo(
        title: "Terra Roxa",
        description: "Solo extremamente fértil, rico em minerais como ferro e alumínio. Possui alta capacidade de retenção de nutrientes e excelente estrutura.",
        tips: [
            "Aproveitar a alta fertilidade para cultivos exigentes.",
            "Manter rotação de culturas para evitar esgotamento.",
            "Aplicar matéria orgânica para manter a estrutura ideal."
        ]
    ),
    
    "Litossolo": SoilInfo(
        title: "Litossolo",
        description: "Solo raso, com pouca profundidade efetiva e baixa capacidade de retenção de água. Muito susceptível à erosão.",
        tips: [
            "Usar cobertura vegetal constante.",
            "Evitar culturas com raízes profundas.",
            "Aplicar matéria orgânica para melhorar retenção de água."
        ]
    )
]

