//
//  SelectVegetable.swift
//  AgroPulse
//
//  Created by Filipi Romão on 03/12/25.
//

import SwiftUI

struct SelectVegetableView: View {
    @StateObject var viewModel = ControlMLViewModel()
    var body: some View {
        Menu("Vegetais"){
            Button("Tomate", action:{
                viewModel.vegetable = .tomato
                viewModel.selectModel(selectedVegetable: .tomato)
            })
            Button("milho", action:{
                viewModel.vegetable = .corn
                viewModel.selectModel(selectedVegetable: .corn)
            })
            Button("soja", action:{
                viewModel.vegetable = .soybean
                viewModel.selectModel(selectedVegetable: .soybean)
            })
        }
        Text("Vegetal: \(viewModel.vegetable)")
    }
}

#Preview {
    SelectVegetableView()
}
