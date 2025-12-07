import SwiftUI
import SwiftData
import Vision


struct ColorTestView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @State private var image: UIImage?
    @State private var showCamera = false
    @State private var showGallery = false
    
    @State private var detectedRect: CGRect = .zero
    @State private var calibrationResult: CalibrationRGB?
    @State private var soilCalibrationResult: CalibrationRGB?
    @State private var correctedSoil: CalibrationRGB?
    
    //    @State private var statusMessage: String = "Selecione uma imagem ou tire uma foto"
    @State var classificationAD: String = ""
    
    @Environment(\.dismiss) var dismiss
    
    private let visionService = VisionService()
    private let colorService = ColorService()
    
    private let referencePaper = CalibrationRGB(red: 255, green: 255, blue: 255)
    
    var body: some View {
        ZStack {
            Color(.systemGray6) // fundo geral
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    imageContainer
                        .padding(20)
                    
                    actionButtons
                        .padding(.horizontal, 20)
                    
                    soilDiagnosisCard
                        .padding(20)
                    
                }
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                )
                .padding(16)
            }
            
        }
        .sheet(isPresented: $showGallery) {
            ImagePicker(image: $image)
        }
        .sheet(isPresented: $showCamera) {
            CameraPicker(image: $image)
        }
        .navigationTitle("Solo")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(8)
                }
            }
        }
        .toolbarBackground(Color("colorPrimal"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
    
    
    // =========================================================================
    // MARK: - PROCESSO DE CALIBRAÇÃO
    // =========================================================================
    func runCalibration() {
        guard let uiImage = image else {
            // statusMessage = "Selecione ou capture uma imagem."
            return
        }
        
        //statusMessage = "Detectando papel..."
        detectedRect = .zero
        
        visionService.detectPaper(in: uiImage) { observation in
            DispatchQueue.main.async {
                guard let paper = observation else {
                    // self.statusMessage = "Nenhum papel detectado."
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
                    // self.statusMessage = "Falha ao calibrar."
                }
                
                if let corrected = self.correctedSoil,
                   let result = self.colorService.classifySoilML(rgb: corrected, modelContext: modelContext) {
                    
                    let soloLabel = result.solo
                    print("Solo detectado: \(soloLabel)")
                    
                    // Salva o nome do solo detectado para exibir no card da UI
                    self.classificationAD = soloLabel
                } else {
                    // self.statusMessage = "Falha ao classificar solo via ML."
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
    
    private var imageContainer: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
                .frame(height: 300)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            
            if let uiImage = image {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .clipped()
                    .cornerRadius(16)
            } else {
                VStack(spacing: 6) {
                    Image(systemName: "camera")
                        .font(.system(size: 50))
                        .foregroundStyle(.secondary)
                    
                    
                    Text("Nenhuma foto selecionada")
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    
    
    private var actionButtons: some View {
        VStack(spacing: 12){
            HStack(spacing: 20) {
                Button(action: { showCamera = true }) {
                    Label("Câmera", systemImage: "camera.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .font(.headline)
                        .background(Color("colorPrimal"))
                        .foregroundColor(.white)
                        .cornerRadius(200)
                }
                
                Button(action: { showGallery = true }) {
                    Label("Galeria", systemImage: "photo.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .font(.headline)
                        .background(Color("colorPrimal"))
                        .foregroundColor(.white)
                        .cornerRadius(200)
                }
            }
            
            Button("Identificar Solo") {
                runCalibration()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .font(.headline)
            .background(Color("colorPrimal"))
            .foregroundColor(.white)
            .cornerRadius(200)
        }
        
    }
    
    
    private var soilDiagnosisCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Tipo de Solo:")
                .font(.headline)
                .foregroundColor(Color("colorPrimal"))
            
            let label = classificationAD.isEmpty ? "..." : classificationAD
            
            Text(label)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
            
            if let info = getSoilInfo(for: classificationAD) {
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text(info.description)
                        .font(.body)
                    
                    Text("Dicas de manejo")
                        .font(.headline)
                        .foregroundColor(Color("colorPrimal"))
                        .padding(.top, 4)
                    
                    ForEach(info.tips, id: \.self) { tip in
                        HStack(alignment: .center) {
                            Circle()
                                .frame(width: 5, height: 5)
                                .foregroundColor(Color("colorPrimal"))
                            Text(tip)
                            //.foregroundColor(.primary)
                        }
                    }
                    
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.gray.opacity(0.1)))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        )
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
