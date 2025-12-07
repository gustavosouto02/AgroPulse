//
//  ModelML.swift
//  AgroHack
//
//  Created by Filipi Romão on 03/12/25.
//

import SwiftUI
import Combine
import CoreML
import UIKit

enum TypeVegetables {
    case tomato
    case soybean
    case corn
}

class ControlMLViewModel: ObservableObject {

    @Published var vegetable: TypeVegetables = .tomato
    @Published var classificationLabel: String = ""
    @Published var prediction: String = ""
    @Published var selectedImageData: Data? = nil

    // MARK: - Seleciona o modelo e faz a previsão
    func selectModel(selectedVegetable: TypeVegetables) {
        do {
            let config = MLModelConfiguration()
            var mlModel: MLModel?

            switch selectedVegetable {
            case .corn:
                mlModel = try ModeloClassificacaoMilho_1(configuration: config).model
            case .soybean:
                mlModel = try ModeloClassificacaoSoja_1(configuration: config).model
            case .tomato:
                mlModel = try ModeloClassificacaoTomate_1(configuration: config).model
            }

            guard let model = mlModel else { return }
            guard let data = selectedImageData, let uiImage = UIImage(data: data) else { return }

            // 1️⃣ Redimensiona mantendo proporção e fundo branco
            let resizedImage = resizeImageKeepingAspect(uiImage, targetSize: CGSize(width: 299, height: 299))

            // 2️⃣ Converte para PixelBuffer compatível com Core ML
            guard let buffer = pixelBuffer(from: resizedImage, width: 299, height: 299) else { return }

            // 3️⃣ Cria input e faz previsão
            let input = try MLDictionaryFeatureProvider(dictionary: ["image": MLFeatureValue(pixelBuffer: buffer)])
            let output = try model.prediction(from: input)

            // 4️⃣ Atualiza label na main thread
            if let label = output.featureValue(for: "target")?.stringValue {
                DispatchQueue.main.async {
                    self.classificationLabel = label
                    print("Prediction:", label)
                }
            }

        } catch {
            print("Erro ao carregar modelo ou prever: \(error)")
        }
    }

    // MARK: - Redimensiona mantendo proporção e centralizando
    private func resizeImageKeepingAspect(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let aspectWidth = targetSize.width / image.size.width
        let aspectHeight = targetSize.height / image.size.height
        let aspectRatio = min(aspectWidth, aspectHeight)

        let newSize = CGSize(width: image.size.width * aspectRatio, height: image.size.height * aspectRatio)
        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            // Fundo branco
            UIColor.white.setFill()
            UIBezierPath(rect: CGRect(origin: .zero, size: targetSize)).fill()

            // Desenha a imagem centralizada
            let x = (targetSize.width - newSize.width) / 2
            let y = (targetSize.height - newSize.height) / 2
            image.draw(in: CGRect(x: x, y: y, width: newSize.width, height: newSize.height))
        }
    }

    // MARK: - Converte UIImage para PixelBuffer compatível com Core ML
    private func pixelBuffer(from image: UIImage, width: Int, height: Int) -> CVPixelBuffer? {
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!
        ] as CFDictionary

        var pixelBuffer: CVPixelBuffer?
        CVPixelBufferCreate(kCFAllocatorDefault, width, height,
                            kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)

        guard let buffer = pixelBuffer else { return nil }

        CVPixelBufferLockBaseAddress(buffer, [])
        defer { CVPixelBufferUnlockBaseAddress(buffer, []) }

        guard let context = CGContext(
            data: CVPixelBufferGetBaseAddress(buffer),
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        ) else { return nil }

        context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
        return buffer
    }
}
