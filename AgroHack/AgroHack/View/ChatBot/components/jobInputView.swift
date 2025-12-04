//
//  jobInputView.swift
//  AgroHack
//
//  Created by Filipi Romão on 04/12/25.
//

import SwiftUI

struct JobInputView: View {
    @ObservedObject var chatVm: ChatBotViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Cole a descrição da vaga")
                .font(.headline)
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity, alignment: .leading)

            TextField(
                "Cole aqui a descrição da vaga...",
                text: $chatVm.jobDescription,
                axis: .vertical
            )
            .lineLimit(5...10)
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.pink.opacity(0.3), lineWidth: 1)
            )

            if chatVm.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                Button(action: chatVm.startTraining) {
                    Text("Iniciar Treino")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                }
                .buttonStyle(.borderedProminent)
                .tint(.pink)
                .controlSize(.large)
                .disabled(chatVm.jobDescription.isEmpty)
            }
            
            
        }
        .padding()
        .background(Color.green)
        .cornerRadius(20)
        
        Spacer()
    }
}
