//
//  HomeView.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 04/12/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            
            // O ZStack garante que o botão flutuante fique por cima (overlay) de tudo
            ZStack(alignment: .bottomTrailing) {
                
                // 1. Conteúdo Principal (Scrollable)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Barra de Pesquisa
                        SearchBarView()
                        
                        // Bloco de Clima
                        Image("WeatherCard")
                        
                        // Plantações Atuais (AGORA SEM O BOTÃO DE ADICIONAR CARD)
                        CurrentCropsSection()
                            .padding(.bottom, 80) // Adiciona espaço no final para o FAB não cobrir o último item
                    }
                    .padding(.top, 10)
                    .padding(.horizontal)
                }
//                .navigationTitle("Olá, Bom Dia")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        VStack(alignment: .leading) {
                            Text("Olá, Bom Dia")
                                .font(.title2)
                                .bold()
                            Text("Domingo, 07 Dez 2025")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            // Ação de Notificação
                        } label: {
                            Image(systemName: "bell.fill")
                                .foregroundColor(Color("colorPrimal"))
                        }
                    }
                }
                .background(Color(.systemBackground))
                
                // 2. Botão Flutuante (Floating Action Button - FAB)
                FloatingAddButton()
                    .padding(.trailing, 20)
                    .padding(.bottom, 10) // Afasta da barra de tabs
            }
        }
    }
}
#Preview {
    HomeView()
}
