//
//  DiseaseAnalysisView.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 06/12/25.
//

//
//  DiseaseAnalysisView.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 06/12/25.
//

import SwiftUI
struct DiseaseAnalysisView: View {
    @StateObject var viewModel = ControlMLViewModel()
    @State private var currentUIImage: UIImage?
    @State private var showCamera = false
    @State private var showGallery = false
    
    var body: some View {
        ZStack {
            Color(.systemGray6) // fundo geral
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Barra verde fininha
                Rectangle()
                    .fill(Color("colorPrimal"))
                    .frame(height: 5)
                    .ignoresSafeArea(.container, edges: .top)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {
                        HeaderDiseases()
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                        
                        PickerPlants()
                            .padding(.horizontal, 20)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray.opacity(0.1))
                                .frame(height: 300)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                            
                            if let image = currentUIImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 300)
                                    .cornerRadius(16)
                            } else {
                                VStack {
                                    Image(systemName: "leaf.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(.green)
                                    Text("Nenhuma foto selecionada")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            Text("Diagnóstico:")
                                .font(.subheadline)
                                .textCase(.uppercase)
                                .foregroundColor(.secondary)
                            
                            let rawLabel = viewModel.classificationLabel
                            let displayLabel = displayLabel(for: rawLabel.isEmpty ? "..." : rawLabel)
                            
                            Text(displayLabel)
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(colorForDiagnosis(displayLabel))
                            
                            if let info = getDiseaseInfo(for: rawLabel),
                               !rawLabel.lowercased().contains("saudável") {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Sobre \(info.title):")
                                        .font(.headline)
                                    Text(info.description)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    Text("Dicas rápidas:")
                                        .font(.headline)
                                    
                                    ForEach(info.tips, id: \.self) { tip in
                                        HStack(alignment: .top) {
                                            Text("•")
                                            Text(tip).font(.subheadline)
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.yellow.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 2)
                        .padding(.horizontal, 20)
                        
                        HStack(spacing: 20) {
                            Button(action: { showCamera = true }) {
                                Label("Câmera", systemImage: "camera.fill")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                            
                            Button(action: { showGallery = true }) {
                                Label("Galeria", systemImage: "photo.fill")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                    .background(Color(.systemGray6)) // <-- garante que o fundo do ScrollView seja cinza
                }
            }
        }
        .sheet(isPresented: $showGallery) {
            ImagePicker(image: $currentUIImage)
        }
        .sheet(isPresented: $showCamera) {
            CameraPicker(image: $currentUIImage)
        }
        .onChange(of: currentUIImage) { _, newImage in
            guard let image = newImage else { return }
            runAnalysis(image: image)
        }
        .onChange(of: viewModel.vegetable) { _, _ in
            if let image = currentUIImage {
                runAnalysis(image: image)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden)
    }

    
    private func runAnalysis(image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            viewModel.selectedImageData = imageData
            viewModel.selectModel(selectedVegetable: viewModel.vegetable)
        }
    }
    
    func colorForDiagnosis(_ text: String) -> Color {
        let lower = text.lowercased()
        if text.isEmpty { return .primary }
        if lower.contains("saudável") || lower.contains("healthy") {
            return .green
        } else {
            return .red
        }
    }
}

#Preview {
    DiseaseAnalysisView()
}
