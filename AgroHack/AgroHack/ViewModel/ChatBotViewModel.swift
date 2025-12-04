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
    @Published var response: String = ""
    @Published var messages: [Message] = []
    @Published var isTraining = false
    @Published var jobDescription: String = ""
    @Published var isLoading: Bool = false
    
    private let manager: ManagerChatProtocol
    private let basePrompt: String = promptCompleto
    
    init(manager: ManagerChatProtocol = ManagerChat()) {
        self.manager = manager
        self.response = "Insira a descrição da vaga para iniciar o treino."
    }

    private func addAIMessage(text: String) {
        messages.append(Message(text: text, isUser: false))
    }
    
    private func addUserMessage(text: String) {
        messages.append(Message(text: text, isUser: true))
    }
    
    func startTraining() {
        print("Entrou em start")
        Task {
            do {
                isTraining = true
                isLoading = true
                
                // Mensagem de loading no chat. AGORA ELA VAI PARA A LISTA
                self.addAIMessage(text: "Analisando sua plantação...")
                
                // Limpar a 'response' assim que o treino começar, para garantir que ela não apareça
                self.response = ""
                
                let result = try await manager.startTraining(jobDescription: jobDescription, prompt: basePrompt)
                
                // Adiciona a primeira pergunta da IA como um novo balão
                self.addAIMessage(text: result)
                
            } catch {
                // Se falhar, voltamos ao estado inicial e atualizamos a 'response'
                self.response = "Erro ao iniciar o treino: \(error.localizedDescription)"
                isTraining = false
            }
            isLoading = false
        }
    }
    
    func sendResponse() {
        Task {
            guard !userPrompt.isEmpty else { return }
            
            // 1. Adiciona a mensagem do usuário à lista (IMEDIATAMENTE)
            let currentPrompt = userPrompt
            self.addUserMessage(text: currentPrompt)
            userPrompt = ""
            
            isLoading = true
            do{
                let result = try await manager.sendMessage(currentPrompt)
                self.addAIMessage(text: result)
            }catch{
                self.addAIMessage(text: "Erro: \(error.localizedDescription)")
            }
           
        
            isLoading = false
        }
    }
}
