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
    
    // Usamos a ViewModel ORIGINAL, sem alterações
    @StateObject var viewModel = ControlMLViewModel()
    
    // Variável local apenas para exibir a foto na tela e controlar o Picker
    @State private var currentUIImage: UIImage?
    
    @State private var showCamera = false
    @State private var showGallery = false
    
    var body: some View {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Dr. Planta")
                        .font(Font.largeTitle.bold())
                    // 1. Seletor de Planta
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
                    
                    // 2. Área da Imagem
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
                    .padding(.horizontal)
                    
                    // 3. Resultado da Análise
                    VStack(spacing: 8) {
                        Text("Diagnóstico:")
                            .font(.subheadline)
                            .textCase(.uppercase)
                            .foregroundColor(.secondary)
                        
                        // Exibimos o classificationLabel da ViewModel original
                        Text(viewModel.classificationLabel.isEmpty ? "..." : viewModel.classificationLabel)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(colorForDiagnosis(viewModel.classificationLabel))
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    .padding(.horizontal)

                    // 4. Botões de Ação
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
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            
            // Sheets para Camera e Galeria
            .sheet(isPresented: $showGallery) {
                ImagePicker(image: $currentUIImage)
            }
            .sheet(isPresented: $showCamera) {
                CameraPicker(image: $currentUIImage)
            }
            
            // -----------------------------------------------------------
            // A MÁGICA ACONTECE AQUI: Conectando UI -> ViewModel Original
            // -----------------------------------------------------------
            
            // 1. Quando o usuário escolhe uma foto nova
            .onChange(of: currentUIImage) { _, newImage in
                guard let image = newImage else { return }
                runAnalysis(image: image)
            }
            
            // 2. Quando o usuário troca a planta (mas já tem foto)
            .onChange(of: viewModel.vegetable) { _, _ in
                if let image = currentUIImage {
                    runAnalysis(image: image)
                }
            }
        }
    
    // Função auxiliar para adaptar os dados para a sua ViewModel antiga
    private func runAnalysis(image: UIImage) {
        // 1. Converte UIImage para Data (que sua VM exige)
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            
            // 2. Injeta na ViewModel
            viewModel.selectedImageData = imageData
            
            // 3. Roda a função original da ViewModel
            viewModel.selectModel(selectedVegetable: viewModel.vegetable)
        }
    }
    
    // Helper visual para cor do texto
    func colorForDiagnosis(_ text: String) -> Color {
        let lower = text.lowercased()
        if text.isEmpty { return .primary }
        if lower.contains("saudável") || lower.contains("healthy") {
            return .green
        } else {
            return .red // Doença detectada
        }
    }
}

#Preview {
    DiseaseAnalysisView()
}
