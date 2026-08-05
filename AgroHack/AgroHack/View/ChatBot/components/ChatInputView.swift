//
//  ChatInputView.swift
//  AgroPulse
//
//  Created by Filipi Romão on 04/12/25.
//

import SwiftUI

struct ChatInputView: View {
    @ObservedObject var chatVm: ChatBotViewModel
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            // Campo de texto
            TextField(
                "Converse sobre sua plantação...",
                text: $chatVm.userPrompt,
                axis: .vertical
            )
            .focused($isTextFieldFocused)
            .lineLimit(1...6)
            .font(.system(size: 15))
            .padding(.leading, 20)
            .padding(.trailing, 12)
            .padding(.vertical, 14)
            .frame(minHeight: 50)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            
            // Botão de enviar
            Button(action: {
                isTextFieldFocused = false
                chatVm.sendResponse()
            }) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(Color("colorPrimal"))
                    )
            }
            .disabled(chatVm.userPrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || chatVm.isLoading)
            .opacity(chatVm.userPrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1.0)
            .padding(.leading, 12)
        }
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color("colorTertiary").opacity(0.15))
                .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 2)
        )
    }
}
