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
    @Published var prediction: String = ""
    @Published var image: UIImage?


    func selectModel(selectedVegetable: TypeVegetables) {
        do {
            let config = MLModelConfiguration()
            var model: MLModel?

            switch selectedVegetable {
            case .corn:
                print("O modelo escolhido é de milho")
                model = try ModeloClassificacaoMilho_1(configuration: config)
                    .model
            case .soybean:
                print("O modelo escolhido é de soja")
                model = try ModeloClassificacaoSoja_1(configuration: config)
                    .model
            case .tomato:
                print("O modelo escolhido é de tomate")
                model = try ModeloClassificacaoTomate_1(configuration: config)
                    .model
            }

            if let model = model {
                if let image = image {
                    let imagePrediction = buffer(from: image)
                    let prediction = try model.prediction(from: imagePrediction as! MLFeatureProvider)
                    print(prediction)
                }
                
            }
           

        } catch {
            print("Error loading model: \(error)")
        }
    }
    
    private func buffer(from image: UIImage) -> CVPixelBuffer? {
      let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
      var pixelBuffer : CVPixelBuffer?
      let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
      guard (status == kCVReturnSuccess) else {
        return nil
      }

      CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
      let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

      let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: image.cgImage?.bitsPerComponent ?? 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

      context?.translateBy(x: 0, y: image.size.height)
      context?.scaleBy(x: 1.0, y: -1.0)

      UIGraphicsPushContext(context!)
      image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
      UIGraphicsPopContext()
      CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

      return pixelBuffer
    }
    
}
