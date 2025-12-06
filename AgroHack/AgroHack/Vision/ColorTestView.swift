import SwiftUI
import Vision

struct ColorTestView: View {
    
    @State private var image: UIImage?
    @State private var showCamera = false
    @State private var showGallery = false
    
    @State private var detectedRect: CGRect = .zero
    @State private var calibrationResult: CalibrationRGB?
    @State private var statusMessage: String = "Selecione uma imagem ou tire uma foto"
    
    private let visionService = VisionService()
    private let colorService = ColorService()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                Text("Calibração de Cor")
                    .font(.headline)
                    .padding(.top)
                
                // IMAGEM
                if let uiImage = image {
                    GeometryReader { geometry in
                        ZStack(alignment: .topLeading) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .overlay(
                                    GeometryReader { imageGeo in
                                        let actualFrame = imageGeo.frame(in: .local)
                                        Rectangle()
                                            .path(in: convertBoundingBox(detectedRect, to: actualFrame))
                                            .stroke(Color.green, lineWidth: 3)
                                    }
                                )
                        }
                    }
                    .frame(height: 400)
                    .padding(.horizontal)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 300)
                        .overlay(Text("Nenhuma imagem"))
                }
                
                // BOTÕES
                HStack {
                    Button("📷 Câmera") {
                        showCamera = true
                    }
                    .buttonStyle(.bordered)
                    
                    Button("🖼️ Galeria") {
                        showGallery = true
                    }
                    .buttonStyle(.bordered)
                }
                
                Button("Calibrar Agora") {
                    runCalibration()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.top, 8)
                
                // RESULTADO
                if let rgb = calibrationResult {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("RGB detectado no papel:")
                            .font(.headline)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(
                                red: Double(rgb.red)/255,
                                green: Double(rgb.green)/255,
                                blue: Double(rgb.blue)/255
                            ))
                            .frame(width: 60, height: 60)
                        
                        Text("R: \(rgb.red)")
                        Text("G: \(rgb.green)")
                        Text("B: \(rgb.blue)")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                Text(statusMessage)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom)
            }
        }
        
        // SHEETS
        .sheet(isPresented: $showGallery) {
            ImagePicker(image: $image)
        }
        .sheet(isPresented: $showCamera) {
            CameraPicker(image: $image)
        }
    }
    
    // PROCESSO DE CALIBRAÇÃO
    func runCalibration() {
        guard let uiImage = image else {
            statusMessage = "Selecione ou capture uma imagem."
            return
        }
        
        statusMessage = "Buscando papel..."
        detectedRect = .zero
        calibrationResult = nil
        
        visionService.detectPaper(in: uiImage) { observation in
            DispatchQueue.main.async {
                guard let paper = observation else {
                    self.statusMessage = "Nenhum papel detectado."
                    return
                }
                
                self.detectedRect = paper.boundingBox
                
                if let rgb = self.colorService.calculateCalibrationFactors(image: uiImage, paperObservation: paper) {
                    self.calibrationResult = rgb
                    self.statusMessage = "Calibração concluída!"
                } else {
                    self.statusMessage = "Falha ao extrair cor."
                }
            }
        }
    }
    
    // Helpers
    func convertBoundingBox(_ box: CGRect, to targetRect: CGRect) -> CGRect {
        let width = box.width * targetRect.width
        let height = box.height * targetRect.height
        let x = box.minX * targetRect.width
        let y = (1 - box.maxY) * targetRect.height
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
