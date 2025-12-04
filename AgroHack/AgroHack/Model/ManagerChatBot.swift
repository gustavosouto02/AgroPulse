//
//  ManagerChatBot.swift
//  AgroHack
//
//  Created by Filipi Romão on 04/12/25.
//

import Foundation
import GoogleGenerativeAI

protocol ManagerChatProtocol {
    func startTraining(jobDescription: String, prompt: String) async throws -> String
    func sendMessage(_ message: String) async throws -> String
}

final class ManagerChat: ManagerChatProtocol {
    private let model = GenerativeModel(name: "gemini-2.5-flash", apiKey: "AIzaSyBERNCHx_f_Oes-67PMtiXn_ZaEktJxfQU")
    private var chat: Chat?
    
    func startTraining(jobDescription: String, prompt: String) async throws -> String {
        chat = model.startChat(history: [
            try ModelContent(role: "user", parts: [
                "\(prompt)\nDescrição da vaga: \(jobDescription)"
            ])
        ])
            
        guard let chat else { return "Erro ao iniciar o chat." }
            
        let result = try await chat.sendMessage("Analise a vaga e inicie as perguntas técnicas.")
        
        guard var text = result.text else {
            return "Erro ao gerar perguntas."
        }

        print(text)

        let logMarker = "---"
        let markerStart = "[INÍCIO DO LOG INTERNO"
            
        if let range = text.range(of: logMarker, options: .literal) {
            text = String(text[..<range.lowerBound])
        }
        else if let range = text.range(of: markerStart, options: .caseInsensitive) {
            text = String(text[..<range.lowerBound])
        }
        
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func sendMessage(_ message: String) async throws -> String {
        guard let chat else { return "Chat não inicializado." }
        let result = try await chat.sendMessage(message)
        return result.text ?? "Erro ao gerar resposta."
    }
}
