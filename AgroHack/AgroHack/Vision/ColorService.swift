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

struct CalibrationRGB {
    var red: Int
    var green: Int
    var blue: Int
}

class ColorService {
    
    // MARK: - RGB do papel
    func calculateCalibrationFactors(image: UIImage, paperObservation: VNRectangleObservation) -> CalibrationRGB? {
        
        guard let cgImage = image.cgImage else { return nil }
        
        let width = Double(cgImage.width)
        let height = Double(cgImage.height)
        
        // Converter bounding box Vision → CGImage
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
    
    
    // MARK: - Média real do RGB 0–255
    private func getAverageColor(of image: CGImage) -> (r: Int, g: Int, b: Int) {
        let ciImage = CIImage(cgImage: image)
        let filter = CIFilter(name: "CIAreaAverage")!
        
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(CIVector(cgRect: ciImage.extent), forKey: kCIInputExtentKey)
        
        guard let outputImage = filter.outputImage else {
            return (255, 255, 255)
        }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: NSNull()])
        
        context.render(
            outputImage,
            toBitmap: &bitmap,
            rowBytes: 4,
            bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
            format: .RGBA8,
            colorSpace: nil
        )
        
        return (Int(bitmap[0]), Int(bitmap[1]), Int(bitmap[2]))
    }
    
    
    // MARK: - RGB do solo (direita)
    func calculateSoilRGBRightSide(image: UIImage, paperObservation: VNRectangleObservation, areaScale: CGFloat = 0.6) -> (rgb: CalibrationRGB?, debugImage: UIImage?) {
        
        guard let cgImage = image.cgImage else { return (nil, nil) }
        
        let imgW = CGFloat(cgImage.width)
        let imgH = CGFloat(cgImage.height)
        
        let paper = paperObservation.boundingBox
        
        // Converter Vision → CGImage
        let paperPx = CGRect(
            x: paper.minX * imgW,
            y: (1 - paper.maxY) * imgH,
            width: paper.width * imgW,
            height: paper.height * imgH
        )
        
        // Área do solo: direita do papel
        let soilWidth = paperPx.width * areaScale
        let offsetX = paperPx.width * 0.4
        
        let soilRect = CGRect(
            x: min(paperPx.maxX + offsetX, imgW - soilWidth),
            y: paperPx.minY,
            width: soilWidth,
            height: paperPx.height
        )
        
        let clippedRect = soilRect.intersection(CGRect(x: 0, y: 0, width: imgW, height: imgH))
        
        guard let soilCg = cgImage.cropping(to: clippedRect) else {
            return (nil, nil)
        }
        
        let avg = getAverageColor(of: soilCg)
        
        let rgb = CalibrationRGB(red: avg.r, green: avg.g, blue: avg.b)
        
        return (rgb, UIImage(cgImage: soilCg))
    }
}


//    func calculateSoilRGB(image: UIImage, paperObservation: VNRectangleObservation, patchSizePx: Int = 100, patchesOffsets: [CGPoint]? = nil) -> CalibrationRGB? {
//        guard let cgImage = image.cgImage else { return nil }
//        let imgW = CGFloat(cgImage.width)
//        let imgH = CGFloat(cgImage.height)
//
//        // Se offsets não vierem, usar offsets relativos ao papel: left, right, below, center-below
//        let defaultOffsets: [CGPoint] = [
//            CGPoint(x: -0.35, y: 0.0),  // à esquerda do papel
//            CGPoint(x:  0.35, y: 0.0),  // à direita do papel
//            CGPoint(x:  0.0,  y: 0.6),  // abaixo do papel (mais perto do solo)
//            CGPoint(x:  0.0,  y: 0.9)   // bem abaixo (muito chão)
//        ]
//        let offsets = patchesOffsets ?? defaultOffsets
//
//        // paper bounding box (VN coordinates: origin bottom-left)
//        let paperBox = paperObservation.boundingBox
//
//        // converter para coordenadas de pixels (x,y com origem em 0,0 no canto inferior esquerdo do CGImage)
//        let paperCenterX = paperBox.midX * imgW
//        let paperCenterY = paperBox.midY * imgH
//
//        var collectedColors: [(r: Int, g: Int, b: Int)] = []
//
//        for offset in offsets {
//            // deslocamento em porcentagem da largura/altura do papel
//            let dx = offset.x * paperBox.width * imgW
//            let dy = offset.y * paperBox.height * imgH
//
//            // centro do patch em pixels
//            let centerX = paperCenterX + dx
//            let centerY = paperCenterY + dy
//
//            // patch rect em coordenadas de pixels. Atenção: CGImage tem origem (0,0) no canto superior-left ao cropar.
//            // Aqui usamos a convenção de pixels com origem no bottom-left -> para cropping precisamos converter Y.
//            let patchW = CGFloat(patchSizePx)
//            let patchH = CGFloat(patchSizePx)
//
//            let cropOriginX = centerX - patchW / 2.0
//            // converter Y (bottom-left) para Y do CGImage (top-left)
//            let cropOriginY = imgH - (centerY + patchH / 2.0)
//
//            let cropRect = CGRect(x: cropOriginX, y: cropOriginY, width: patchW, height: patchH).intersection(CGRect(x: 0, y: 0, width: imgW, height: imgH))
//
//            // se patch muito pequeno, pular
//            if cropRect.width < 10 || cropRect.height < 10 { continue }
//
//            if let patchCg = cgImage.cropping(to: cropRect) {
//                let avg = getAverageColor(of: patchCg)
//                collectedColors.append(avg)
//            }
//        }
//
//        guard !collectedColors.isEmpty else { return nil }
//
//        // calcular média simples dos patches
//        let sum = collectedColors.reduce((r: 0, g: 0, b: 0)) { acc, c in
//            (acc.r + c.r, acc.g + c.g, acc.b + c.b)
//        }
//        let count = collectedColors.count
//        return CalibrationRGB(red: sum.r / count, green: sum.g / count, blue: sum.b / count)
//    }
//}
