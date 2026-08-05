//
//  BestSeasonModel.swift
//  AgroPulse
//
//  Created by Filipi Romão on 06/12/25.
//

import Foundation

struct BestSeasonResponse: Codable {
    let meta: Meta
    let data: [BestSeasonModel]
}

struct Meta: Codable {
    let totalCount: Int
}

struct BestSeasonModel: Codable{
    var municipio: String
    var uf: String
    var cultura: String
    var culturaSafra: String
    var culturaCultivo: String
    var culturaClima: String
    var ciclo: String
    var solo: String
    var diaIni: Int
    var mesIni: Int
    var diaFim: Int
    var mesFim: Int
    var safraIni: Int
    var safraFim: Int
    var risco: Int
    var portaria: String
}
