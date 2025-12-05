//
//  ChatBotView.swift
//  AgroHack
//

import GoogleGenerativeAI
import SwiftUI

struct ChatBotView: View {

    @EnvironmentObject var chatVm: ChatBotViewModel
    var plant: PlantModel?
        
    var body: some View {

        VStack {

            // ------------------------
            // HEADER CUSTOMIZADO (mantido)
            // ------------------------
            if let plant = plant {
                HStack(spacing: 12) {
                    if let data = plant.image,
                       let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "leaf.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.green)
                    }
                    
                    Text(plant.name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(Color(.systemGray6))
                .cornerRadius(12)

                Divider()
                    .background(Color(.colorPrimal))
                
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Chat da colheita")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color.colorPrimal)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // ------------------------
            // ÁREA DO CHAT
            // ------------------------
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(chatVm.messages) { message in
                            ChatBubbleView(message: message)
                                .id(message.id)
                        }

                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 1)
                            .id("bottomAnchor")
                    }
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity)
                }
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 5, y: 5)
                .scrollDismissesKeyboard(.interactively)
            }

            ChatInputView(chatVm: chatVm)
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
        .background(Color(.systemBackground))
        .navigationBarHidden(false)
        .navigationBarTitleDisplayMode(.inline)

        // ------------------------
        // TÍTULO DA BARRA (ATIVO AO MESMO TEMPO)
        // ------------------------
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(plant?.name ?? "Chat da colheita")
                    .font(.headline)
            }
        }
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
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .frame(maxWidth: 320, alignment: .leading)

                    Spacer()

                } else {
                    Spacer()

                    Text(message.text)
                        .font(.body)
                        .padding(12)
                        .background(Color.colorSecondary)
                        .foregroundColor(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .frame(maxWidth: 320, alignment: .trailing)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 2)
        }
    }
}
