//
//  ChatBotViewModel.swift
//  AgroHack
//
//  Created by Filipi Romão on 04/12/25.
//

import Foundation
import Combine

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
    
    private let manager: ManagerChatProtocol
    
    init(manager: ManagerChatProtocol = ManagerChat()) {
        self.manager = manager
    }

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

