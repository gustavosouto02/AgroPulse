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
    
    struct SoilStats {
        let name: String
        let mean: (r: Double, g: Double, b: Double)
        let std: (r: Double, g: Double, b: Double)
    }

    let soilDataset: [SoilStats] = [
        SoilStats(
            name: "Latossolo",
            mean: (160.29, 68.71, 41.14),
            std: (41.93, 28.62, 25.49)
        ),
        SoilStats(
            name: "Litossolo",
            mean: (149.20, 116.00, 86.60),
            std: (27.72, 23.57, 20.71)
        ),
        SoilStats(
            name: "Terra Roxa",
            mean: (93.60, 47.80, 74.00),
            std: (33.38, 27.33, 30.09)
        )
    ]
    

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
                                
                                // --- NOVA IMPLEMENTAÇÃO ---
                                if let corrected = self.correctedSoil {
                                    
                                    // 1. Converter Int para Double para o cálculo estatístico
                                    let inputRGB = (
                                        r: Double(corrected.red),
                                        g: Double(corrected.green),
                                        b: Double(corrected.blue)
                                    )
                                    
                                    // 2. Chamar o método estatístico (Z-Score / Mahalanobis)
                                    let (soilName, score) = self.identifySoil(rgb: inputRGB, dataset: self.soilDataset)
                                    
                                    // 3. Interpretar a confiança baseada no Score (Desvios Padrão)
                                    // Score < 1.0 = Muito próximo da média (Alta confiança)
                                    // Score < 2.0 = Dentro de 2 desvios padrão (Média confiança)
                                    // Score > 3.0 = Outlier (Baixa confiança)
                                    let confidence: String
                                    if score < 1.0 { confidence = "Alta" }
                                    else if score < 2.5 { confidence = "Média" }
                                    else { confidence = "Baixa" }
                                    
                                    // 4. Atualizar UI
                                    self.statusMessage = "Solo: \(soilName)\nConfiança: \(confidence) (Score: \(String(format: "%.2f", score)))"
                                }


//                if self.correctedSoil != nil {
//                    self.statusMessage = "Calibração concluída!"
//                } else {
//                    self.statusMessage = "Falha ao calibrar."
//                }
//                
//                if let corrected = self.correctedSoil {
//                    let soilClass = classifySoil(rgb: corrected)
//                    self.statusMessage = "Calibração concluída! Solo classificado: \(soilClass)"
//                }
            }
        }
    }
    
//    func weightedDistance(from rgb: CalibrationRGB, to soil: SoilStats) -> Double {
//        let wR = 1 / soil.std.r
//        let wG = 1 / soil.std.g
//        let wB = 1 / soil.std.b
//
//        let dr = (Double(rgb.red) - soil.mean.r) * wR
//        let dg = (Double(rgb.green) - soil.mean.g) * wG
//        let db = (Double(rgb.blue) - soil.mean.b) * wB
//
//        return sqrt(dr*dr + dg*dg + db*db)
//    }
//    
//    func classifySoil(rgb: CalibrationRGB) -> String {
//        // Ordena pelo menor distância
//        let sorted = soilDataset.sorted { weightedDistance(from: rgb, to: $0) < weightedDistance(from: rgb, to: $1) }
//        
//        // Pega os 3 mais próximos
//        let top3 = sorted.prefix(3)
//        
//        // Conta os votos
//        var counts: [String: Int] = [:]
//        for soil in top3 {
//            counts[soil.name, default: 0] += 1
//        }
//        
//        // Retorna o mais votado
//        return counts.max(by: { $0.value < $1.value })?.key ?? "Desconhecido"
//    }

    func identifySoil(rgb: (r: Double, g: Double, b: Double), dataset: [SoilStats]) -> (String, Double) {
        var bestMatch: String = "Desconhecido"
        var lowestScore: Double = Double.infinity

        for soil in dataset {
            // Calcula o Z-Score para cada canal (distância normalizada pelo desvio padrão)
            let zR = pow((rgb.r - soil.mean.r) / soil.std.r, 2)
            let zG = pow((rgb.g - soil.mean.g) / soil.std.g, 2)
            let zB = pow((rgb.b - soil.mean.b) / soil.std.b, 2)
            
            // Distância de Mahalanobis simplificada (assumindo canais independentes)
            let score = sqrt(zR + zG + zB)
            
            if score < lowestScore {
                lowestScore = score
                bestMatch = soil.name
            }
        }
        
        return (bestMatch, lowestScore)
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

