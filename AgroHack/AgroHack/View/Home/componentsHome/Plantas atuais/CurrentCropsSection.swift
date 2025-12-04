//
//  CurrentCropsSection.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 04/12/25.
//

import SwiftUI
import SwiftData

struct CurrentCropsSection: View {

    @Query(sort: \PlantModel.name) var plants: [PlantModel]

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Plantações Atuais")
                    .font(.headline)
                Spacer()
                Text("Ver todas")
                    .font(.subheadline)
            }
            .padding(.top)

            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(plants) { plant in
                    NavigationLink(value: plant) {
                        CropCardView(plant: plant)
                    }
                }
            }
        }
    }
}


#Preview {
    CurrentCropsSection()
}
