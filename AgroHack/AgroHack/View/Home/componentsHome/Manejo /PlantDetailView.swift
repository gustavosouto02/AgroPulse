//
//  PlantDetailView.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 04/12/25.
//

import SwiftUI

struct PlantDetailView: View {
    @EnvironmentObject var chatVm: ChatBotViewModel
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
                    .padding(.horizontal)

                Text(plant.name)
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)

                // Ciclo de Vida
                LifeCycleSection(estagio: plant.estagio)

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
                    .navigationBarHidden(true)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .navigationTitle(plant.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
