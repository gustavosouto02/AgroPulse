//
//  PickerPlants.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 06/12/25.
//

import SwiftUI

struct PickerPlants: View {
    @ObservedObject var viewModel : ControlMLViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Selecione a cultura:")
                .font(.headline)
                //.foregroundColor(.gray)
            
            Menu {
                Button("Tomate") { viewModel.vegetable = .tomato }
                Button("Milho") { viewModel.vegetable = .corn }
                Button("Soja") { viewModel.vegetable = .soybean }
            } label: {
                HStack {
                    Text(displayName(for: viewModel.vegetable))
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3))
                )
            }
        }
    }
    
    private func displayName(for vegetable: TypeVegetables) -> String {
        switch vegetable {
        case .tomato: return "Tomate"
        case .corn: return "Milho"
        case .soybean: return "Soja"
        }
    }
}
