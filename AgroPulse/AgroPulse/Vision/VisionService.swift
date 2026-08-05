//
//  VisionService.swift
//  AgroPulse
//
//  Created by Gustavo Souto Pereira on 05/12/25.
//

import Foundation
import SwiftUI
import Vision
import CoreImage
import UIKit

class VisionService {
    
    private let context = CIContext()
    
    /// Detecta o retângulo mais "claro" (papel), ignorando objetos escuros como Bíblia, capa, etc.
    func detectPaper(in image: UIImage, completion: @escaping (VNRectangleObservation?) -> Void) {
        
        // Converter para CGImage
        guard let cgImage = image.cgImage else {
            print("Erro: Não foi possível converter a imagem.")
            completion(nil)
            return
        }
        
        // Criar a requisição para detectar até 5 retângulos
        let request = VNDetectRectanglesRequest { [weak self] request, error in
            
            if let error = error {
                print("Erro no Vision: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let observations = request.results as? [VNRectangleObservation], !observations.isEmpty else {
                print("Nenhum retângulo encontrado.")
                completion(nil)
                return
            }
            
            print("Retângulos detectados: \(observations.count)")
            
            // Map each observation to a tuple (observation, brightness) and pick the brightest explicitly
            let candidates: [(obs: VNRectangleObservation, brightness: CGFloat)] = observations.compactMap { obs in
                guard let brightness = self?.averageBrightness(of: obs, in: cgImage) else { return nil }
                return (obs: obs, brightness: brightness)
            }
            let brightest = candidates.max(by: { lhs, rhs in
                lhs.brightness < rhs.brightness
            })
            
            if let best = brightest {
                print("Maior brilho encontrado: \(best.brightness)")
                completion(best.obs)
            } else {
                completion(nil)
            }
        }
        
        // CONFIGURAÇÕES DO VISION (melhor precisão)
        request.minimumConfidence = 0.7
        request.minimumAspectRatio = 0.4
        request.maximumObservations = 3   // agora analisamos até 5
        request.quadratureTolerance = 45
        
        // Executar
        let handler = VNImageRequestHandler(
            cgImage: cgImage,
            orientation: CGImagePropertyOrientation(image.imageOrientation)
        )
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("Erro ao executar handler: \(error)")
                completion(nil)
            }
        }
    }
    
    
    // MARK: - Cálculo de brilho médio do retângulo detectado
    
    private func averageBrightness(of rect: VNRectangleObservation, in cgImage: CGImage) -> CGFloat? {

        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)

        // ⚠️ CORREÇÃO AQUI → NÃO inverter o Y
        let pts = [
            rect.topLeft, rect.topRight,
            rect.bottomLeft, rect.bottomRight
        ].map { CGPoint(x: $0.x * width, y: $0.y * height) }

        // Bounding box
        let minX = pts.map { $0.x }.min() ?? 0
        let maxX = pts.map { $0.x }.max() ?? 0
        let minY = pts.map { $0.y }.min() ?? 0
        let maxY = pts.map { $0.y }.max() ?? 0

        let cropRect = CGRect(x: minX,
                              y: minY,
                              width: maxX - minX,
                              height: maxY - minY)

        let ciImage = CIImage(cgImage: cgImage).cropped(to: cropRect)
        let extent = ciImage.extent

        guard let filter = CIFilter(name: "CIAreaAverage") else { return nil }
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(CIVector(cgRect: extent), forKey: kCIInputExtentKey)

        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)

        let r = CGFloat(bitmap[0]) / 255.0
        let g = CGFloat(bitmap[1]) / 255.0
        let b = CGFloat(bitmap[2]) / 255.0

        return 0.299 * r + 0.587 * g + 0.114 * b
    }

}

extension CGImagePropertyOrientation {
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
        case .up: self = .up
        case .down: self = .down
        case .left: self = .left
        case .right: self = .right
        case .upMirrored: self = .upMirrored
        case .downMirrored: self = .downMirrored
        case .leftMirrored: self = .leftMirrored
        case .rightMirrored: self = .rightMirrored
        @unknown default:
            self = .up
        }
    }
}
