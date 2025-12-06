import PhotosUI
import SwiftUI

struct AddPlantView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @StateObject var addPlantViewModel = AddPlantViewModel()
    @StateObject var viewModel = ControlMLViewModel()
    @State private var selectedPhoto: PhotosPickerItem? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // MARK: - Foto
                VStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemGray5))
                            .frame(height: 180)

                        if let data = viewModel.selectedImageData,
                            let uiImage = UIImage(data: data)
                        {

                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 180)
                                .clipShape(RoundedRectangle(cornerRadius: 20))

                        } else {
                            VStack(spacing: 8) {
                                Image(systemName: "camera")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)

                                Text("Adicionar foto da plantação")
                                    .foregroundColor(.gray)
                            }
                        }
                    }

                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        Text("Selecionar Foto")
                            .font(.body)
                            .foregroundColor(.blue)
                    }
                }
                .padding()

                // MARK: - Card Nome & Cultura

                VStack {
                    iconField(
                        icon: "pencil",
                        placeholder: "Nome",
                        text: $addPlantViewModel.name
                    )
                    Divider()
                    iconField(
                        icon: "leaf",
                        placeholder: "Espécie plantada",
                        text: $addPlantViewModel.cultura
                    )
                }
                .padding()
                .frame(width: 363)
                .background(Color.white)
                .cornerRadius(18)
                .shadow(color: Color.black.opacity(0.05), radius: 5, y: 3)
                .padding(.horizontal)



                VStack {
                    Text("Ciclo de Vida")
                        .font(.headline)
                        .padding(.bottom, 4)
                    HStack {
                        DatePicker(
                            "Inicio",
                            selection: $addPlantViewModel.dataGerminacao,
                            displayedComponents: .date
                        )
                        .padding()
                    }
                    .frame(width: 337, height: 47)
                    .background(Color(.systemGray5))
                    .cornerRadius(16)
                }
                .padding()
                .frame(width: 363)
                .background(Color.white)
                .cornerRadius(18)
                .shadow(color: Color.black.opacity(0.05), radius: 5, y: 3)
                .padding(.horizontal)

                // MARK: - Informações da Cultura
                VStack(alignment: .leading, spacing: 12) {
                    Text("Informações da Cultura")
                        .font(.headline)
                        .padding(.bottom, 4)

                    iconField(
                        icon: "square.grid.2x2",
                        placeholder: "Tipo de solo",
                        text: $addPlantViewModel.solo
                    )
                    iconField(
                        icon: "cloud.sun",
                        placeholder: "Clima",
                        text: $addPlantViewModel.clima
                    )
                    iconField(
                        icon: "ruler",
                        placeholder: "Área plantada",
                        text: $addPlantViewModel.area
                    )
                    Menu{
                        Button("Inicial"){
                            addPlantViewModel.estagio = .Inicial
                        }
                        Button("Crescimento"){
                            addPlantViewModel.estagio = .Crescimento
                        }
                        Button("Floracao"){
                            addPlantViewModel.estagio = .Floracao
                        }
                        Button("Colheita"){
                            addPlantViewModel.estagio = .Colheita
                        }
                    } label:{
                        HStack{
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.gray)
                            Text("Estágio atual")

                        }
                    }

                    // PRAGAS
                    Menu {
                        Button("Sim") { addPlantViewModel.temPraga = true }
                        Button("Não") { addPlantViewModel.temPraga = false }
                    } label: {
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.gray)
                            Text("Já teve pragas?")
                            Spacer()
                        }
                    }

                    if addPlantViewModel.temPraga {
                        iconField(
                            icon: "ant.fill",
                            placeholder: "Qual praga?",
                            text: $addPlantViewModel.praga
                        )
                    }

                    // FERTILIZANTE
                    Menu {
                        Button("Sim") {
                            addPlantViewModel.usaFertilizante = true
                        }
                        Button("Não") {
                            addPlantViewModel.usaFertilizante = false
                        }
                    } label: {
                        HStack {
                            Image(systemName: "drop")
                                .foregroundColor(.gray)
                            Text("Usa fertilizante?")
                            Spacer()
                        }
                    }

                    if addPlantViewModel.usaFertilizante {
                        iconField(
                            icon: "flask.fill",
                            placeholder: "Tipo de fertilizante",
                            text: $addPlantViewModel.fertlizantes
                        )
                    }
                }
                .padding()
                .frame(width: 363)
                .background(Color.white)
                .cornerRadius(18)
                .shadow(color: Color.black.opacity(0.05), radius: 5, y: 3)
                .padding(.horizontal)

                // MARK: - Botão
                Button {
                    addPlantViewModel.salvar(context: modelContext)
                } label: {
                    Text("Salvar nova colheita")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("colorPrimal"))
                        .cornerRadius(30)
                        .padding(.horizontal)
                }
                .padding(.bottom, 40)
            }
        }
        .background(Color(.systemGray6))
        .onChange(of: selectedPhoto) {
            Task {
                if let data = try? await selectedPhoto?.loadTransferable(
                    type: Data.self
                ) {
                    viewModel.selectedImageData = data
                    addPlantViewModel.image = data
                }
            }
        }
        .navigationTitle("Nova plantação")
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
        
        // Configuração da Barra de Navegação Colorida
        .toolbarBackground(Color("colorPrimal"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        
    }
}

// MARK: - COMPONENTES DE UI
extension AddPlantView {
  

    /// Campo com ícone à esquerda
    func iconField(icon: String, placeholder: String, text: Binding<String>)
        -> some View
    {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
            TextField(placeholder, text: text)
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(12)
    }

}
