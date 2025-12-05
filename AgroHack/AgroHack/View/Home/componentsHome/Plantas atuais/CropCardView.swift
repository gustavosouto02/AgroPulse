//
//  CropCardView.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 04/12/25.
//

import SwiftUI

struct CropCardView: View {
    let plant: PlantModel

    var body: some View {
        VStack(alignment: .leading) {

            // imagem vinda do Data
            if let data = plant.image, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 100)
                    .clipped()
            } else {
                Color.gray.opacity(0.2)
                    .frame(height: 100)
                    .overlay(Text("Sem imagem"))
            }

            VStack(alignment: .leading, spacing: 6) {

                Text(plant.name)
                    .font(.headline)

                // 🔥 Linha de progresso com o mesmo padrão do LifeCycleSection
                GrowthProgressMiniView(
                    steps: ["Germinação", "Crescimento", "Floração", "Colheita"],
                    current: plant.estagio
                )
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1),
                radius: 5, x: 0, y: 2)
    }
}


struct FloatingAddButton: View {
    var body: some View {
        NavigationLink(destination: AddPlantView(), label: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 60, height: 60) // Tamanho maior para um FAB
                .foregroundColor(Color("colorPrimal"))
                .background(Color.white) // Fundo branco para destaque, se necessário
                .clipShape(Circle())
                .shadow(radius: 5) //
        })
//        Button {
//            // Ação: Abrir tela para adicionar nova plantação
//            print("Adicionar nova plantação")
//        } label: {
//            Image(systemName: "plus.circle.fill")
//                .resizable()
//                .frame(width: 60, height: 60) // Tamanho maior para um FAB
//                .foregroundColor(Color("colorPrimal"))
//                .background(Color.white) // Fundo branco para destaque, se necessário
//                .clipShape(Circle())
//                .shadow(radius: 5) // Sombra para dar o efeito flutuante
//        }
    }
}

