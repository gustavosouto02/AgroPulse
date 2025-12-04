//
//  AddPlantView.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 03/12/25.
//

import Foundation
import SwiftUI
import PhotosUI

struct AddPlantView: View {
    @StateObject var viewModel = ControlMLViewModel()
    @State private var name = ""
    @State private var selectedPhoto: PhotosPickerItem? = nil
//    @State private var selectedImageData: Data? = nil
    var body: some View {
        Form{
            Section{
                HStack{
                    Spacer()
                    
                    if let data = viewModel.selectedImageData, let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                        
                        } else {
                            PhotoComponent()
                        }
                        
                    Spacer()
                }
                
                HStack{
                    Spacer()
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        Text("Selecionar Foto")
                    }
                    Spacer()
                }
                VStack{
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
                    Text("Resultado: \(viewModel.classificationLabel)")
                }
            }

        }
        .onChange(of: selectedPhoto) {
            Task {
                if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                    viewModel.selectedImageData = data
                }
                
            }
        }
    }
}

