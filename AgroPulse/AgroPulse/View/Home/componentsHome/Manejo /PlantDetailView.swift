//
//  PlantDetailView.swift
//  AgroPulse
//
//  Created by Gustavo Souto Pereira on 04/12/25.
//

import SwiftUI

struct PlantDetailView: View {

    @Environment(\.dismiss) private var dismiss
    let plant: PlantModel
    
    var image: Image {
        if let data = plant.image,
           let uiImage = UIImage(data: data)
        {
            return Image(uiImage: uiImage)
        }
        return Image("placeholder")
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 20) {
                
                // FOTO
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(14)
                    .padding()
                
                Text(plant.name)
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)
                
                // Ciclo de Vida
                LifeCycleSection(plant: plant)
                
                // Manejo e Cuidados
                CareSection(plant: plant)
                
                NavigationLink(destination: ChatBotView(plant: plant)) {
                    HStack {
                        Text("Falar com IA sobre \(plant.name)")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.colorPrimal)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .navigationTitle(plant.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
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
        
        // Configuração da Barra de Navegação Colorida
        .toolbarBackground(Color("colorPrimal"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
