//
//  ChatBotView.swift
//  AgroHack
//
//  Created by Filipi Romão on 04/12/25.
//

import GoogleGenerativeAI
import SwiftUI

struct ChatBotView: View {

    @ObservedObject var chatVm: ChatBotViewModel
   

    var body: some View {
        // 1. A VStack agora é a view principal (não está mais dentro de um ZStack)
        VStack(spacing: 15) {
            
            // 2. Header (sem alteração)
            VStack(alignment: .leading, spacing: 0) {
                Text("Chat da colheita")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color.colorPrimal)

            }
            .foregroundStyle(Color.colorPrimal)
            .padding(.top, 32)
            .frame(maxWidth: .infinity, alignment: .leading)
            

            // 3. Área do Chat (ScrollViewReader)
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(chatVm.messages) { message in
                            ChatBubbleView(message: message)
                                .id(message.id)
                        }
                        Rectangle().fill(Color.clear).frame(
                            height: 1
                        ).id("bottomAnchor")
                    }
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity)
                }
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 5, y: 5)
                .frame(
                    alignment: .top
                )
                .frame(maxWidth: .infinity)
                .scrollDismissesKeyboard(.interactively)


            }
            ChatInputView(chatVm: chatVm)


        }
        .padding(.horizontal)
        .padding(.bottom, 8)
        .background(Color(.systemBackground))
        
        
    
        
    }

    struct ChatBubbleView: View {
        let message: Message

        var body: some View {
            HStack {
                if !message.isUser {

                    Text(.init(message.text))
                        .font(.body)
                        .padding(12)
                        .background(Color.colorTertiary)
                        .foregroundColor(.black)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 15,
                                style: .continuous
                            )
                        )
                        .frame(maxWidth: 320, alignment: .leading)
                        .multilineTextAlignment(.leading)

                    Spacer()

                } else {

                    Spacer()

                    Text(message.text)
                        .font(.body)
                        .padding(12)
                        .background(Color.colorSecondary)
                        .foregroundColor(.black)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 15,
                                style: .continuous
                            )
                        )
                        .frame(maxWidth: 320, alignment: .trailing)
                        .multilineTextAlignment(.trailing)

                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 2)
        }
        
    
    }
        
}

