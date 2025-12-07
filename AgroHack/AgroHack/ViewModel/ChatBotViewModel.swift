//
//  ChatBotViewModel.swift
//  AgroHack
//
//  Created by Filipi Romão on 04/12/25.
//

import Combine
import Foundation

struct Message: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

@MainActor
class ChatBotViewModel: ObservableObject {
    @Published var userPrompt: String = ""
    @Published var messages: [Message] = []
    @Published var isLoading: Bool = false

    //private let manager: ManagerChatProtocol
    private let manager: ManagerChat
    var plantModel: PlantModel?
    init() { // 1. Inicializador sem argumentos para o App.swift
            // Inicialize o manager sem planta
            self.manager = ManagerChat(plantModel: nil)
        }
    
    func configureChat(with plant: PlantModel) {
            // Define a planta no Manager
            manager.setPlant(plant)
            
            // Limpa mensagens anteriores
            messages = []
            
            // Inicia a conversa com o prompt inicial (opcional: ou use a função startTraining)
            // Por enquanto, apenas limpa e prepara o Manager.
        }
    
//    init(plantModel: PlantModel?) {
//        self.plantModel = plantModel
//
//        // transforma PlantModel em PlantInfo
//        let plant = PlantModel(
//            id: UUID(),
//            name: plantModel?.name ?? "",
//            cultura: plantModel?.cultura ?? "",
//            solo: plantModel?.solo ?? "",
//            clima: plantModel?.clima ?? "",
//            area: plantModel?.area ?? "",
//            estagio: plantModel?.estagio ?? .Inicial,
//            fertilizantes: plantModel?.fertilizantes ?? "",
//            irrigacao: plantModel?.irrigacao ?? "",
//            tipoPraga: plantModel?.tipoPraga ?? ""
//        )
//
//        self.manager = ManagerChat(plantModel: plant)
//    }

    private func addAIMessage(_ text: String) {
        messages.append(Message(text: text, isUser: false))
    }

    private func addUserMessage(_ text: String) {
        messages.append(Message(text: text, isUser: true))
    }

    func sendResponse() {
        Task {
            guard !userPrompt.isEmpty else { return }

            let userText = userPrompt
            addUserMessage(userText)
            userPrompt = ""

            isLoading = true

            do {
                let result = try await manager.sendMessage(userText)
                addAIMessage(result)
            } catch {
                addAIMessage("Erro: \(error.localizedDescription)")
            }

            isLoading = false
        }
    }
}
