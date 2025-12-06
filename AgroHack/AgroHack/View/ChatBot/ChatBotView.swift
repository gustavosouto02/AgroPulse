//
//  ChatBotView.swift
//  AgroHack
//

import GoogleGenerativeAI
import SwiftUI

struct ChatBotView: View {

    @EnvironmentObject var chatVm: ChatBotViewModel
    @Environment(\.dismiss) private var dismiss
    var plant: PlantModel?
    
    var body: some View {
        //        ZStack(alignment: .top) {
        //            // Background
        //            Color(.systemBackground)
        //                .ignoresSafeArea()
        
        VStack(spacing: 0) {
            // Header customizado
            //                ChatHeaderView(
            //                    plantName: plant?.name ?? "Chat da colheita",
            //                    showBackButton: plant != nil,
            //                    onBack: { dismiss() }
            //                )
            //
            // Planta info (se houver)
            if let plant = plant {
                PlantInfoBar(plant: plant)
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
            }
            
            // Área do chat

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(chatVm.messages) { message in
                            ChatBubbleView(message: message)
                                .id(message.id)
                        }
                        
                        // Indicador de carregamento
                        if chatVm.isLoading {
                            TypingIndicatorView()
                                .id("typingIndicator")
                        }
                        
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 1)
                            .id("bottomAnchor")
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: chatVm.messages.count) { _ in
                    withAnimation {
                        proxy.scrollTo("bottomAnchor", anchor: .bottom)
                    }
                }
                .onChange(of: chatVm.isLoading) { isLoading in
                    if isLoading {
                        withAnimation {
                            proxy.scrollTo("typingIndicator", anchor: .bottom)
                        }
                    }
                }
            }
            
            // Input area
            ChatInputView(chatVm: chatVm)
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
        }
        .navigationTitle(plant?.name ?? "Chat da colheita")
        .navigationBarTitleDisplayMode(.inline)
        
        // --- ESTILO IGUAL AO NOTIFICATION VIEW ---
        .toolbarBackground(Color("colorPrimal"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar) // Texto branco
        
        // LÓGICA DO BOTÃO VOLTAR:
        // Só esconde o nativo e mostra o customizado se tiver uma planta (significa que foi pushed da Home)
        .navigationBarBackButtonHidden(plant != nil)
        .toolbar {
            if plant != nil {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding(8)
                    }
                }
            }
        }
        
    }
    
    // MARK: - Header Component
    struct ChatHeaderView: View {
        let plantName: String
        let showBackButton: Bool
        let onBack: () -> Void
        
        var body: some View {
            ZStack {
                // Background verde
                Color("colorPrimal")
                    .ignoresSafeArea(edges: .top)
                
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 50)
                    
                    HStack {
                        if showBackButton {
                            Button(action: onBack) {
                                HStack(spacing: 4) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text("Detalhes")
                                        .font(.system(size: 16))
                                }
                                .foregroundStyle(.white)
                            }
                        } else {
                            Spacer()
                        }
                        
                        Spacer()
                        
                        Text("Chat da colheita")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        if showBackButton {
                            // Espaço para manter o título centralizado quando há botão
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Detalhes")
                                    .font(.system(size: 16))
                            }
                            .opacity(0)
                        } else {
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
                }
            }
            .frame(height: 100)
        }
    }
    
    // MARK: - Plant Info Bar
    struct PlantInfoBar: View {
        let plant: PlantModel
        
        var body: some View {
            HStack(spacing: 12) {
                if let data = plant.image,
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "leaf.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color("colorPrimal"))
                }
                
                Text(plant.name)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
        }
    }
    
    // MARK: - Chat Bubble
    struct ChatBubbleView: View {
        let message: Message
        
        var body: some View {
            HStack(alignment: .bottom, spacing: 0) {
                if message.isUser {
                    Spacer(minLength: 50)
                    
                    Text(message.text)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .lineSpacing(3)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 14)
                        .background(
                            UnevenRoundedRectangle(
                                topLeadingRadius: 20,
                                bottomLeadingRadius: 20,
                                bottomTrailingRadius: 4,
                                topTrailingRadius: 20,
                                style: .continuous
                            )
                            .fill(Color("colorPrimal").opacity(0.2))
                        )
                } else {
                    Text(.init(message.text))
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .lineSpacing(3)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 14)
                        .background(
                            UnevenRoundedRectangle(
                                topLeadingRadius: 20,
                                bottomLeadingRadius: 4,
                                bottomTrailingRadius: 20,
                                topTrailingRadius: 20,
                                style: .continuous
                            )
                            .fill(Color(.systemGray5))
                        )
                    
                    Spacer(minLength: 50)
                }
            }
        }
    }
    
    // MARK: - Typing Indicator
    struct TypingIndicatorView: View {
        @State private var animatingDots = false
        
        var body: some View {
            HStack(alignment: .bottom, spacing: 0) {
                HStack(spacing: 6) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Color.gray.opacity(0.6))
                            .frame(width: 8, height: 8)
                            .scaleEffect(animatingDots ? 1.2 : 0.6)
                            .opacity(animatingDots ? 1.0 : 0.4)
                            .animation(
                                Animation.easeInOut(duration: 0.6)
                                    .repeatForever()
                                    .delay(Double(index) * 0.2),
                                value: animatingDots
                            )
                    }
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
                .background(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 20,
                        bottomLeadingRadius: 4,
                        bottomTrailingRadius: 20,
                        topTrailingRadius: 20,
                        style: .continuous
                    )
                    .fill(Color(.systemGray5))
                )
                
                Spacer(minLength: 50)
            }
            .onAppear {
                animatingDots = true
            }
        }
    }
}
