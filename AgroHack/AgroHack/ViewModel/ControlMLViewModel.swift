//
//  ModelML.swift
//  AgroHack
//
//  Created by Filipi Romão on 03/12/25.
//

import Combine
import CoreML
import Foundation
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
    private var image: UIImage?

    func selectModel(selectedVegetable: TypeVegetables) {
        do {
            let config = MLModelConfiguration()
            var mlModel: MLModel?
            print("Selected vegetable:", selectedVegetable)

            switch selectedVegetable {
            case .corn:
                mlModel = try ModeloClassificacaoMilho_1(configuration: config).model
            case .soybean:
                mlModel = try ModeloClassificacaoSoja_1(configuration: config).model
            case .tomato:
                mlModel = try ModeloClassificacaoTomate_1(configuration: config).model
            }

            guard let model = mlModel else { return }
            guard let data = selectedImageData, let uiImage = convertDataToUIImage(data: data) else { return }
            let resizedImage = resizeImage(
                uiImage,
                targetSize: CGSize(width: 299, height: 299)
            )

            guard let buffer = bufferImage(resizedImage) else {

                return
            }

            let input = try MLDictionaryFeatureProvider(
                dictionary: ["image": MLFeatureValue(pixelBuffer: buffer)]
            )

            let output = try model.prediction(from: input)

            if let label = output.featureValue(for: "target")?.stringValue {
                DispatchQueue.main.async {
                    self.classificationLabel = label
                    print(label)
                }
            }


        } catch {
            print("Error loading model / predicting: \(error)")
        }
    }

    private func convertDataToUIImage(data: Data) -> UIImage? {
        UIImage(data: data)
    }

    private func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

    func bufferImage(_ image: UIImage) -> CVPixelBuffer? {
        let width = Int(image.size.width)
        let height = Int(image.size.height)

        var pixelBuffer: CVPixelBuffer?
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!
        ] as CFDictionary

        CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            kCVPixelFormatType_32BGRA,
            attrs,
            &pixelBuffer
        )

        guard let buffer = pixelBuffer else { return nil }

        CVPixelBufferLockBaseAddress(buffer, [])

        guard let context = CGContext(
            data: CVPixelBufferGetBaseAddress(buffer),
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
        ) else {
            CVPixelBufferUnlockBaseAddress(buffer, [])
            return nil
        }

        guard let cgImage = image.cgImage else {
            CVPixelBufferUnlockBaseAddress(buffer, [])
            return nil
        }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        CVPixelBufferUnlockBaseAddress(buffer, [])

        return buffer
    }


}
