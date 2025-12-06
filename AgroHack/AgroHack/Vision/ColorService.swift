//
//  ColorService.swift.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 06/12/25.
//

import Foundation
import UIKit
import Vision
import CoreImage
import CoreML
import SwiftData

struct CalibrationRGB {
    var red: Int
    var green: Int
    var blue: Int
}

class ColorService {
    
    var nomeSolo: String = ""
    var tipoSolo: String = ""
    var classificacaoAD: String = ""
    let solo: EnumTiposSolo = .Latossolo
    
    private let mlModel: ClassificacaoSolosPorCor = {
        do {
            let config = MLModelConfiguration()
            return try ClassificacaoSolosPorCor(configuration: config)
        } catch {
            fatalError("Erro ao carregar modelo ML: \(error)")
        }
    }()
    
    // MARK: - RGB do papel
    func calculateCalibrationFactors(image: UIImage, paperObservation: VNRectangleObservation) -> CalibrationRGB? {
        
        guard let cgImage = image.cgImage else { return nil }
        
        let width = Double(cgImage.width)
        let height = Double(cgImage.height)
        
        let cropRect = CGRect(
            x: paperObservation.boundingBox.minX * width,
            y: (1 - paperObservation.boundingBox.maxY) * height,
            width: paperObservation.boundingBox.width * width,
            height: paperObservation.boundingBox.height * height
        )
        
        guard let croppedRef = cgImage.cropping(to: cropRect) else { return nil }
        
        let avg = getAverageColor(of: croppedRef)
        return CalibrationRGB(red: avg.r, green: avg.g, blue: avg.b)
    }
    
    // MARK: - RGB do solo (direita)
    func calculateSoilRGBRightSide(image: UIImage, paperObservation: VNRectangleObservation, areaScale: CGFloat = 0.6) -> (rgb: CalibrationRGB?, debugImage: UIImage?) {
        
        guard let cgImage = image.cgImage else { return (nil, nil) }
        
        let imgW = CGFloat(cgImage.width)
        let imgH = CGFloat(cgImage.height)
        let paper = paperObservation.boundingBox
        
        let paperPx = CGRect(
            x: paper.minX * imgW,
            y: (1 - paper.maxY) * imgH,
            width: paper.width * imgW,
            height: paper.height * imgH
        )
        
        let soilWidth = paperPx.width * areaScale
        let offsetX = paperPx.width * 0.4
        
        let soilRect = CGRect(
            x: min(paperPx.maxX + offsetX, imgW - soilWidth),
            y: paperPx.minY,
            width: soilWidth,
            height: paperPx.height
        )
        
        let clippedRect = soilRect.intersection(CGRect(x: 0, y: 0, width: imgW, height: imgH))
        
        guard let soilCg = cgImage.cropping(to: clippedRect) else { return (nil, nil) }
        
        let avg = getAverageColor(of: soilCg)
        let rgb = CalibrationRGB(red: avg.r, green: avg.g, blue: avg.b)
        
        return (rgb, UIImage(cgImage: soilCg))
    }
    
    // MARK: - Média real do RGB 0–255
    private func getAverageColor(of image: CGImage) -> (r: Int, g: Int, b: Int) {
        let ciImage = CIImage(cgImage: image)
        let filter = CIFilter(name: "CIAreaAverage")!
        
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(CIVector(cgRect: ciImage.extent), forKey: kCIInputExtentKey)
        
        guard let outputImage = filter.outputImage else { return (255, 255, 255) }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: NSNull()])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        
        return (Int(bitmap[0]), Int(bitmap[1]), Int(bitmap[2]))
    }
    
    // MARK: - Classificação via Core ML
    func classifySoilML(rgb: CalibrationRGB, modelContext: ModelContext) -> (solo: String, probabilities: [String: Double])? {
        do {
            let input = ClassificacaoSolosPorCorInput(
                R: Int64(rgb.red),
                G: Int64(rgb.green),
                B: Int64(rgb.blue)
            )
            
            let prediction = try mlModel.prediction(input: input)
            
            tipoSolo = prediction.Solo
            switch solo{
            case .Latossolo:
                classificacaoAD = "AD1"
            case .Litossolo:
                classificacaoAD = "AD2"
            case .TerraRoxa:
                classificacaoAD = "AD4"
            }
            nomeSolo = prediction.Solo
            saveModelSolo(modelContext: modelContext)
            
            return (solo: prediction.Solo, probabilities: prediction.SoloProbability)
            
        } catch {
            print("Erro na previsão ML: \(error)")
            return nil
        }
    }
    
    func saveModelSolo(modelContext: ModelContext){
        let solo = SoloModel(name: nomeSolo,typeSolo: tipoSolo, classificationAD: classificacaoAD)
        modelContext.insert(solo)
        print("Valores salvos: \(solo.name)")
        try? modelContext.save()
        print("Depois do salvos: \(solo.name)")
    }
}
