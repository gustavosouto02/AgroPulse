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
        apiKey: "AIzaSyBERNCHx_f_Oes-67PMtiXn_ZaEktJxfQU"
    )
    private var chat: Chat?

    var plantInfo: PlantInfo?

    private func ensureChat() throws {
        if chat == nil {
            chat = model.startChat(history: [
                try ModelContent(
                    role: "user",
                    parts: [
                        "Descrição da plantação: \(PlantInfo(cultura: "trigo", solo: "arenoso", clima: "arido", area: "800 hectares", estagio: "inicial", fertilizantes: "nao uso", irrigacao: "a cada 2 semanas"))"
                    ]
                )
            ])
        }
    }

    func startTraining(prompt: String) async throws -> String {

        // cria o chat já com o histórico inicial
        chat = model.startChat(history: [
            try ModelContent(
                role: "user",
                parts: [
                    "\(prompt)\nDescrição da plantação: \(PlantInfo(cultura: "trigo", solo: "arenoso", clima: "arido", area: "800 hectares", estagio: "inicial", fertilizantes: "nao uso", irrigacao: "a cada 2 semanas"))"
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
