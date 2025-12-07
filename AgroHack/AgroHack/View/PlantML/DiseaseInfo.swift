//
//  DiseaseInfo.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 06/12/25.
//

import Foundation

// MARK: - Informações sobre a doença
struct DiseaseInfo {
    let title: String
    let description: String
    let cause: String
    let tips: [String]
}

let labelMap: [String: String] = [
    "pintaPreta": "Pinta Preta",
    "ferrugem": "Ferrugem",
    "Ferrugem": "Ferrugem",
    "manchaPurpura": "Mancha Púrpura",
    "manchaCercospora": "Mancha de Cercospora",
    "saudavel": "Saudável"
]

func displayLabel(for label: String) -> String {
    labelMap[label] ?? label
}

func getDiseaseInfo(for label: String) -> DiseaseInfo? {
    guard let key = labelMap[label] else { return nil }
    return diseaseDatabase[key]
}

// Um dicionário rápido com doenças e dicas
let diseaseDatabase: [String: DiseaseInfo] = [
    "Ferrugem": DiseaseInfo(
        title: "Ferrugem do Milho",
        description: "Caracteriza-se pela formação de **pústulas** (pequenas bolhas) que se rompem, liberando uma massa de esporos de coloração **alaranjada a marrom-avermelhada** nas folhas. Reduz a área fotossintética e a produtividade.",
        cause: "Fungos dos gêneros *Puccinia* ou *Physopella* (dependendo do tipo de ferrugem).",
        tips: [
            "**Monitoramento Constante:** Iniciar a inspeção logo após o florescimento.",
            "**Cultivares Resistentes:** Preferir sementes com boa resistência genética.",
            "**Controle Químico:** Aplicar fungicidas (geralmente triazóis e estrobilurinas) de forma preventiva ou no início da doença, seguindo o estádio da cultura.",
            "**Rotação de Culturas:** Embora os esporos possam ser transportados pelo vento, a rotação ajuda a reduzir o inóculo na área."
        ]
    ),
    
    "Mancha de Cercospora": DiseaseInfo(
        title: "Mancha de Cercospora (Cercosporiose)",
        description: "Provoca **lesões necróticas alongadas, de cor cinza-clara a bronzeada**, com margens escuras bem definidas, frequentemente limitadas pelas nervuras da folha. É mais severa em condições de alta umidade e temperatura.",
        cause: "Fungo *Cercospora zeae-maydis*.",
        tips: [
            "**Manejo de Resíduos:** Fazer o enterrio ou a remoção da palhada, pois o fungo sobrevive em restos culturais.",
            "**Rotação de Culturas:** Essencial para reduzir o inóculo inicial no solo (não rotacionar com outras gramíneas).",
            "**Cultivares Tolerantes/Resistentes:** Selecionar híbridos com maior tolerância à doença.",
            "**Controle Químico:** Aplicações de fungicidas (principalmente triazóis e estrobilurinas) conforme o nível de severidade e o zoneamento de risco."
        ]
    ),
    
    "Pinta Preta": DiseaseInfo(
            title: "Pinta Preta ou Mancha-Alvo do Tomate",
            description: "Forma manchas concêntricas (alvo) de coloração escura em folhas, hastes e frutos. Causa desfolha severa, expondo os frutos e reduzindo o valor comercial.",
            cause: "Fungo *Corynespora cassiicola*.",
            tips: [
                "**Sementes Sadias:** Usar sementes certificadas e tratadas.",
                "**Ventilação:** Evitar excesso de umidade na lavoura (evitar irrigação por aspersão no final da tarde).",
                "**Eliminação de Inóculo:** Remover e destruir restos culturais e plantas velhas (cultura do ciclo anterior).",
                "**Controle Químico:** Aplicação regular de fungicidas protetores e sistêmicos, principalmente no período de frutificação."
            ]
        ),
    
    "Mancha Púrpura": DiseaseInfo(
            title: "Mancha Púrpura da Soja (Cercosporiose)",
            description: "Causa descoloração púrpura (rosa-púrpura a arroxeada) nas sementes, mas também pode aparecer nas folhas como manchas necróticas arredondadas (Cercospora foliar). Reduz a qualidade da semente e o vigor da plântula.",
            cause: "Fungo *Cercospora kikuchii*.",
            tips: [
                "**Tratamento de Sementes:** Essencial para reduzir o inóculo transmitido.",
                "**Rotação de Culturas:** Ajuda a diminuir a fonte de inóculo no campo.",
                "**Cultivares Tolerantes:** Escolher variedades menos suscetíveis.",
                "**Controle Químico:** Aplicações foliares tardias de fungicidas (R5.1 a R6) podem ser necessárias se a incidência foliar for alta para proteger a qualidade da semente."
            ]
        )
]


