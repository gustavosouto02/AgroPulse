//
//  CropCardView.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 04/12/25.
//

import SwiftUI

struct CropCardView: View {
    let crop: Crop
    
    var body: some View {
        VStack(alignment: .leading) {
            // Imagem do topo
            Image(crop.imageName) // Certifique-se de ter as imagens no seu Assets
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 100)
                .clipped()
            
            VStack(alignment: .leading) {
                Text(crop.name)
                    .font(.headline)
                
                // Simulação da barra de progresso
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color("colorPrimal")) // Verde escuro para o progresso
                        .frame(width: 8, height: 8)
                    Circle()
                        .fill(Color("colorPrimal"))
                        .frame(width: 8, height: 8)
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 8, height: 8)
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
            
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct FloatingAddButton: View {
    var body: some View {
        Button {
            // Ação: Abrir tela para adicionar nova plantação
            print("Adicionar nova plantação")
        } label: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 60, height: 60) // Tamanho maior para um FAB
                .foregroundColor(Color("colorPrimal"))
                .background(Color.white) // Fundo branco para destaque, se necessário
                .clipShape(Circle())
                .shadow(radius: 5) // Sombra para dar o efeito flutuante
        }
    }
}

