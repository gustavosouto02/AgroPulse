//
//  HomeView.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 04/12/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {

    // Altura do Header (ajuste conforme o layout)
    //let headerHeight: CGFloat = 260
    @Query(sort: \PlantModel.name) var plants: [PlantModel]
    @Environment(\.modelContext) private var context
    @EnvironmentObject var chatVm: ChatBotViewModel

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {

                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(alignment: .leading) {
                        // HEADER FIXO COMO FUNDO
                        HeaderHome()
                            .ignoresSafeArea(edges: .top)
                            .padding(.top, -70)

                        // WEATHER CARD (agora dentro do scroll)
                        Image("WeatherCard")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal)
                            .padding(.top, -100)
                        
                        NavigationLink(destination: SearchBestSeasonView(), label: {
                            HStack{
                                Text("Saiba a melhor época para o seu plantio")
                                    .font(.headline)
                                    .foregroundColor(Color.colorPrimal)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color.colorPrimal)
                            }
                            .background(Color.colorSecondary)
                            .shadow(radius: 12)
                            .cornerRadius(16)
                            .frame(width: 363, height: 56)
                            .padding()
                        })
        
                        CurrentCropsSection()
                            .padding()
                    }
                    .onAppear {
                        seedDataIfNeeded()
                    }

                }
                .navigationDestination(for: PlantModel.self) { plant in
                    PlantDetailView(plant: plant)
                        .environmentObject(chatVm)
                }
                .navigationDestination(for: String.self) { value in
                    if value == "NotificationView" {
                        NotificationView()
                    }
                }
            

                // FAB
                FloatingAddButton()
                    .padding(.trailing, 20)
                    .padding(.bottom, 10)
                    .frame(maxHeight: .infinity, alignment: .bottomTrailing)
            }.background(Color.secondary.opacity(0.2))
        }
    }
    func seedDataIfNeeded() {
        let count = (try? context.fetch(FetchDescriptor<PlantModel>()).count) ?? 0
        if count > 0 { return } // já tem dados, não cria de novo
        
        print("🌱 Inserindo plantações iniciais no SwiftData…")

        let predefinedPlants: [(name: String, asset: String, cultura: String, solo: String, clima: String, area: String, estagio: StepsGrowthType, fertilizantes: String, irrigacao: String)] = [
            ("Trigo", "trigo", "Cereal", "Areno-argiloso", "Temperado", "2 hectares", .Crescimento, "NPK 04-14-08", "Moderada"),
            ("Café", "cafe", "Grão", "Argiloso", "Tropical", "1 hectare", .Inicial, "Composto orgânico", "Regular"),
            ("Milho", "milho", "Cereal", "Areno-argiloso", "Subtropical", "3 hectares", .Floracao, "NPK 20-05-20", "Alta"),
            ("Pimenta", "pimenta", "Hortaliça", "Leve e drenado", "Quente", "0.5 hectare", .Colheita, "Adubo orgânico", "Moderada")
        ]
        
        for plant in predefinedPlants {
            let imageData = UIImage(named: plant.asset)?.jpegData(compressionQuality: 0.9)

            let now = Date()

            let newPlant = PlantModel(
                id: UUID(),
                name: plant.name,
                image: imageData,
                cultura: plant.cultura,
                solo: plant.solo,
                clima: plant.clima,
                area: plant.area,
                estagio: plant.estagio,
                fertilizantes: plant.fertilizantes,
                irrigacao: plant.irrigacao,
                dataGerminacao: now.addingTimeInterval(-86400 * 40),  // 40 dias atrás
                dataColheita: now.addingTimeInterval(86400 * 20),      // 20 dias no futuro
                tipoPraga: "Pulga",
                ultimaRega: now.addingTimeInterval(-86400 * 1),
                       // 1 dia atrás
                ultimaAdubacao: now.addingTimeInterval(-86400 * 15),  // 15 dias atrás
                ultimaPraga: now.addingTimeInterval(-86400 * 30),     // 30 dias atrás
                ultimoTratamento: now.addingTimeInterval(-86400 * 10) // 10 dias atrás
            )

            
            context.insert(newPlant)
        }
        
        print("🌾 Plantas iniciais criadas com sucesso!")
    }
}



#Preview {
    HomeView()
}
