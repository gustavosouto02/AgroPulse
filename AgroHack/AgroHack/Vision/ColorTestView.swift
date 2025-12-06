import SwiftUI
import Vision


struct ColorTestView: View {

    @State private var image: UIImage?
    @State private var showCamera = false
    @State private var showGallery = false

    @State private var detectedRect: CGRect = .zero
    @State private var calibrationResult: CalibrationRGB?
    @State private var soilCalibrationResult: CalibrationRGB?
    @State private var correctedSoil: CalibrationRGB?

    @State private var statusMessage: String = "Selecione uma imagem ou tire uma foto"

    private let visionService = VisionService()
    private let colorService = ColorService()

    private let referencePaper = CalibrationRGB(red: 255, green: 255, blue: 255)

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                Text("Calibração de Cor")
                    .font(.headline)
                    .padding(.top)

                // ------------------------------------------------------------
                //              IMAGEM DO USUÁRIO
                // ------------------------------------------------------------
                if let uiImage = image {
                    GeometryReader { geometry in
                        ZStack {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width)

                            GeometryReader { geo in
                                let frame = geo.frame(in: .local)
                                Rectangle()
                                    .path(in: convertBoundingBox(detectedRect, to: frame))
                                    .stroke(Color.green, lineWidth: 3)
                            }
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

                // ------------------------------------------------------------
                //               BOTÕES DE ENTRADA
                // ------------------------------------------------------------
                HStack {
                    Button("📷 Câmera") { showCamera = true }
                        .buttonStyle(.bordered)

                    Button("🖼️ Galeria") { showGallery = true }
                        .buttonStyle(.bordered)
                }

                Button("Calibrar Agora") {
                    runCalibration()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)


                // ------------------------------------------------------------
                //           RESULTADOS DO PAPEL
                // ------------------------------------------------------------
                if let paper = calibrationResult {

                    Text("Papel detectado").font(.title3.bold())

                    HStack(spacing: 20) {
                        colorBox(title: "Real (255,255,255)", rgb: referencePaper)
                        colorBox(title: "Detectado", rgb: paper)
                    }
                }

                // ------------------------------------------------------------
                //           SOLO CAPTURADO + CORRIGIDO
                // ------------------------------------------------------------
                if let soil = soilCalibrationResult, let corrected = correctedSoil {

                    Text("Solo detectado").font(.title3.bold())

                    HStack(spacing: 20) {
                        colorBox(title: "Capturado", rgb: soil)
                        colorBox(title: "Corrigido", rgb: corrected)
                    }
                }
                
              // Text("Calibração concluída! Solo classificado: \(soilClass))"

                Text(statusMessage)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom)
            }
        }
        .sheet(isPresented: $showGallery) {
            ImagePicker(image: $image)
        }
        .sheet(isPresented: $showCamera) {
            CameraPicker(image: $image)
        }
    }


    // =========================================================================
    // MARK: - PROCESSO DE CALIBRAÇÃO
    // =========================================================================
    func runCalibration() {
        guard let uiImage = image else {
            statusMessage = "Selecione ou capture uma imagem."
            return
        }

        statusMessage = "Detectando papel..."
        detectedRect = .zero

        visionService.detectPaper(in: uiImage) { observation in
            DispatchQueue.main.async {
                guard let paper = observation else {
                    self.statusMessage = "Nenhum papel detectado."
                    return
                }

                self.detectedRect = paper.boundingBox

                // RGB do papel
                if let paperRGB = self.colorService.calculateCalibrationFactors(image: uiImage, paperObservation: paper) {
                    self.calibrationResult = paperRGB
                }

                // RGB solo (função retorna uma tupla (rgb: CalibrationRGB?, debugImage: UIImage?))
                let soilResult = self.colorService.calculateSoilRGBRightSide(image: uiImage, paperObservation: paper)
                if let soilRGB = soilResult.rgb {
                    self.soilCalibrationResult = soilRGB
                }
                // Se você quiser usar a imagem de debug futuramente, ela está em soilResult.debugImage

                // Solo corrigido
                if let soilRGB = self.soilCalibrationResult, let paperRGB = self.calibrationResult {
                    self.correctedSoil = calculateCorrectedSoilColor(
                        paperRGB: paperRGB,
                        soilRGB: soilRGB,
                        referencePaperRGB: referencePaper
                    )
                }
                
                if self.correctedSoil != nil {
                                    // self.statusMessage = "Calibração concluída!" // Remover essa linha antiga
                                } else {
                                    self.statusMessage = "Falha ao calibrar."
                                }
                                
                if let corrected = self.correctedSoil {
                    if let result = self.colorService.classifySoilML(rgb: corrected) {
                        let soloName = result.solo
                        let confidence = result.probabilities[soloName] ?? 0.0
                        self.statusMessage = "Solo: \(soloName)\nConfiança: \(String(format: "%.2f", confidence * 100))%"
                    } else {
                        self.statusMessage = "Falha ao classificar solo via ML."
                    }
                }
            }
        }
    }

    // =========================================================================
    // MARK: - UI Helper
    // =========================================================================
    func colorBox(title: String, rgb: CalibrationRGB) -> some View {
        VStack {
            Text(title).font(.subheadline)

            RoundedRectangle(cornerRadius: 10)
                .fill(Color(
                    red: Double(rgb.red)/255,
                    green: Double(rgb.green)/255,
                    blue: Double(rgb.blue)/255
                ))
                .frame(width: 70, height: 70)

            Text("R: \(rgb.red)")
            Text("G: \(rgb.green)")
            Text("B: \(rgb.blue)")
        }
        .padding(10)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }


    // =========================================================================
    // MARK: - Correção da cor do solo
    // =========================================================================
    func calculateCorrectedSoilColor(
        paperRGB: CalibrationRGB,
        soilRGB: CalibrationRGB,
        referencePaperRGB: CalibrationRGB
    ) -> CalibrationRGB {

        func correct(channel soil: Int, paper: Int, reference: Int) -> Int {
            guard paper > 0 else { return soil }
            let corrected = Double(soil) * (Double(reference) / Double(paper))
            return Int(min(255, max(0, corrected)))
        }

        return CalibrationRGB(
            red: correct(channel: soilRGB.red, paper: paperRGB.red, reference: referencePaperRGB.red),
            green: correct(channel: soilRGB.green, paper: paperRGB.green, reference: referencePaperRGB.green),
            blue: correct(channel: soilRGB.blue, paper: paperRGB.blue, reference: referencePaperRGB.blue)
        )
    }

    // =========================================================================
    // MARK: - Bounding box conversão
    // =========================================================================
    func convertBoundingBox(_ box: CGRect, to target: CGRect) -> CGRect {
        CGRect(
            x: box.minX * target.width,
            y: (1 - box.maxY) * target.height,
            width: box.width * target.width,
            height: box.height * target.height
        )
    }
}

