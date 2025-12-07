//
//  PickerPlants.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 06/12/25.
//

import SwiftUI

struct PickerPlants: View {
    @ObservedObject var viewModel = ControlMLViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            Text("Selecione a cultura:")
                .font(.headline)
                .foregroundColor(.gray)
            
            // Mapeamos o Enum TypeVegetables para a UI
            Picker("Cultura", selection: $viewModel.vegetable) {
                Text("Tomate").tag(TypeVegetables.tomato)
                Text("Milho").tag(TypeVegetables.corn)
                Text("Soja").tag(TypeVegetables.soybean)
            }
            .pickerStyle(.segmented)
        }
        .padding(.horizontal)
    }
}

#Preview {
    PickerPlants()
}
