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
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {

                    PickerPlants()
                        .padding(.horizontal, 20)
                        .padding(.top)

                    imageContainer
                        .padding(.horizontal, 20)

                    diagnosisCard
                        .padding(.horizontal, 20)

                    actionButtons
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
                
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                )
                .padding(16)
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
        .navigationTitle("Folhas")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(8)
                }
            }
        }
        .toolbarBackground(Color("colorPrimal"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    // MARK: - Subviews

    private var imageContainer: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
                .frame(height: 300)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )

            if let image = currentUIImage {
                GeometryReader { geo in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                }
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                VStack(spacing: 6) {
                    Image(systemName: "camera")
                        .font(.system(size: 50))
                        .foregroundStyle(.secondary)

                    Text("Nenhuma foto selecionada")
                        .foregroundColor(.gray)
                }
            }
        }
    }


    private var diagnosisCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Diagnóstico:")
                .font(.headline)
                .foregroundColor(Color("colorPrimal"))

            let rawLabel = viewModel.classificationLabel
            let safeRaw = rawLabel.isEmpty ? "..." : rawLabel
            let label = displayLabel(for: safeRaw)

            Text(label)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            if let info = getDiseaseInfo(for: rawLabel),
               !rawLabel.lowercased().contains("saudável") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sobre \(info.title):")
                        .font(.headline)
                        .foregroundColor(Color("colorPrimal"))
                    Text(info.description)

                    Text("Dicas rápidas:")
                        .font(.headline)
                        .foregroundColor(Color("colorPrimal"))

                    ForEach(info.tips, id: \.self) { tip in
                        HStack(alignment: .center) {
                            Circle()
                                .frame(width: 5, height: 5)
                                .foregroundColor(Color("colorPrimal"))
                            Text(tip)
                        }
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.gray.opacity(0.1)))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        )
    }

    private var actionButtons: some View {
        HStack(spacing: 20) {
            Button(action: { showCamera = true }) {
                Label("Câmera", systemImage: "camera.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .font(.headline)
                    .background(Color("colorPrimal"))
                    .foregroundColor(.white)
                    .cornerRadius(200)
            }

            Button(action: { showGallery = true }) {
                Label("Galeria", systemImage: "photo.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .font(.headline)
                    .background(Color("colorPrimal"))
                    .foregroundColor(.white)
                    .cornerRadius(200)
            }
        }
    }

    // MARK: - Helpers

    private func runAnalysis(image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            viewModel.selectedImageData = imageData
            viewModel.selectModel(selectedVegetable: viewModel.vegetable)
        }
    }
}

#Preview {
    DiseaseAnalysisView()
}
