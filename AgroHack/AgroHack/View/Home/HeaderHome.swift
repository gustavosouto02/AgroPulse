//
//  HeaderHome.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 04/12/25.
//

import SwiftUI

struct HeaderHome: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // Espaço de segurança para a Status Bar
            Spacer()
                .frame(height: 50)
            
            // Conteúdo (Título e Botão de Notificação)
            HStack(alignment: .center) {
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Olá, Bom Dia")
                        .font(.title2)
                        .bold()
                    // Data em cor secundária (dentro do tema escuro)
                    Text("Domingo, 07 Dez 2025")
                        .font(.caption)
                }
                .foregroundStyle(.white)
                
                Spacer()
                
                Button {
                    // Ação de Notificação
                } label: {
                    Image(systemName: "bell.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white) // Ícone BRANCO
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 20)
            
            SearchBarView()
                .padding(.horizontal, 20)
            
            Spacer()
                .frame(height: 120)

            
        }
        .frame(maxWidth: .infinity)
        .background(Color("colorPrimal")) // Fundo verde escuro
        
        // Aplica o canto arredondado APENAS na parte inferior do Header
        .clipShape(RoundedRectangle(cornerRadius: 60, style: .continuous))
        .edgesIgnoringSafeArea(.top) // Garante que a cor vá até o topo da tela
    }
}

#Preview {
    HeaderHome()
}
