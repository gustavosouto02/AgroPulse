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
    
    func calculateCalibrationFactors(image: UIImage, paperObservation: VNRectangleObservation) -> CalibrationRGB? {
        
        guard let cgImage = image.cgImage else { return nil }
        
        let width = Double(cgImage.width)
        let height = Double(cgImage.height)
        
        // Conversão Vision → CGImage (invertendo Y)
        let cropRect = CGRect(
            x: paperObservation.boundingBox.minX * width,
            y: (1 - paperObservation.boundingBox.maxY) * height,
            width: paperObservation.boundingBox.width * width,
            height: paperObservation.boundingBox.height * height
        )
        
        guard let croppedRef = cgImage.cropping(to: cropRect) else { return nil }
        
        // Média REAL em 0–255
        let averageColor = getAverageColor(of: croppedRef)
        
        return CalibrationRGB(
            red: averageColor.r,
            green: averageColor.g,
            blue: averageColor.b
        )
    }
    
    // Média real do RGB em 0–255
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
        
        // Agora cada canal já está de 0 a 255
        return (Int(bitmap[0]), Int(bitmap[1]), Int(bitmap[2]))
    }
}
