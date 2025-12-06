//
//  ManagerChatBot.swift
//  AgroHack
//
//  Created by Filipi Romão on 04/12/25.
//

import Foundation
import GoogleGenerativeAI

protocol ManagerChatProtocol {
    func startTraining(prompt: String) async throws -> String
    func sendMessage(_ message: String) async throws -> String
}

final class ManagerChat: ManagerChatProtocol {
    private let model = GenerativeModel(
        name: "gemini-2.5-flash",
        apiKey: "AIzaSyDka8BowwJQAx-1bJU-oVzgV1UthjvNoXI"
            //        apiKey: "AIzaSyBERNCHx_f_Oes-67PMtiXn_ZaEktJxfQU"
    )
    private var chat: Chat?

    private var plantModel: PlantModel?

    init(plantModel: PlantModel?) {
        self.plantModel = plantModel
    }

    private func ensureChat() throws {
        if chat == nil {
            if let plantModel {
                chat = model.startChat(history: [
                    try ModelContent(
                        role: "user",
                        parts: [
                            "Descrição da plantação: nome:\(plantModel.name),tipo de solo: \(plantModel.solo), tipo de clima: \(plantModel.clima) ,estagio: \(plantModel.estagio), area: \(plantModel.area), fertilizante: \(plantModel.fertilizantes),praga que já teve: \(plantModel.tipoPraga), historico de irrigação: \(plantModel.irrigacao)"
                        ]
                    )
                ])

            }
        }
    }

    func startTraining(prompt: String) async throws -> String {

        guard let plantModel else { return "Erro ao buscar model para o chat." }

        // cria o chat já com o histórico inicial
        chat = model.startChat(history: [

            try ModelContent(
                role: "user",
                parts: [
                    "\(prompt)\nDescrição da plantação: nome:\(plantModel.name),tipo de solo: \(plantModel.solo), tipo de clima: \(plantModel.clima) ,estagio: \(plantModel.estagio), area: \(plantModel.area), fertilizante: \(plantModel.fertilizantes),praga que já teve: \(plantModel.tipoPraga), historico de irrigação: \(plantModel.irrigacao)"
                ]
            )

        ])

        guard let chat else { return "Erro ao iniciar o chat." }

        let result = try await chat.sendMessage(
            "Analise a vaga e inicie as perguntas técnicas."
        )
        guard var text = result.text else { return "Erro ao gerar perguntas." }

        // Remove logs internos caso existam
        if let range = text.range(of: "---") {
            text = String(text[..<range.lowerBound])
        }

        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func sendMessage(_ message: String) async throws -> String {
        try ensureChat()
        let result = try await chat!.sendMessage(message)
        return result.text ?? "Erro ao gerar resposta."
    }
}
extension PlantInfo {
    static var empty: PlantModel {
        PlantModel(
            id: UUID(),
            name: "não informado",
            cultura: "não informada",
            solo: "não informado",
            clima: "não informado",
            area: "não informada",
            estagio: StepsGrowthType.Inicial,
            fertilizantes: "não informado",
            irrigacao: "não informado",
            tipoPraga: "não informado"
        )
    }
}
