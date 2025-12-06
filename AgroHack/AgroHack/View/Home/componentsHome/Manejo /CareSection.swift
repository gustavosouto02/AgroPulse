//
//  CareSection.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 04/12/25.
//

import SwiftUI

struct CareSection: View {

    @Bindable var plant: PlantModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Manejo e Cuidados")
                .font(.headline)


            HStack {
                Image(systemName: "drop.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.blue)
                Text("Última rega")
                Spacer()
                DatePicker(
                    "",
                    selection: Binding(
                        get: { plant.ultimaRega ?? Date() },
                        set: { plant.ultimaRega = $0 }
                    ),
                    displayedComponents: .date
                )
            }
            
            HStack {
                Image(systemName: "apple.meditate.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.brown)
                Text("Última adubação")
                Spacer()
                DatePicker(
                    "",
                    selection: Binding(
                        get: { plant.ultimaAdubacao ?? Date() },
                        set: { plant.ultimaAdubacao = $0 }
                    ),
                    displayedComponents: .date
                )
            }
            
            HStack {
                Image(systemName: "allergens.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.green)
                Text("Última praga")
                Spacer()
                DatePicker(
                    "",
                    selection: Binding(
                        get: { plant.ultimaPraga ?? Date() },
                        set: { plant.ultimaPraga = $0 }
                    ),
                    displayedComponents: .date
                )
            }
            
            HStack {
                Image(systemName: "cross.vial.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.blue)
                Text("Último tratamento")
                Spacer()
                DatePicker(
                    "",
                    selection: Binding(
                        get: { plant.ultimoTratamento ?? Date() },
                        set: { plant.ultimoTratamento = $0 }
                    ),
                    displayedComponents: .date
                )
            }
            
        }
        .padding()
        .background(.white)
        .cornerRadius(12)
        .shadow(radius: 3)
        .padding(.horizontal)
    }

//    func info(icon: String, title: String, value: String) -> some View {
//        HStack {
//            Image(systemName: icon)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 20, height: 20)
//                .foregroundColor(.green)
//            Text(title)
//            Spacer()
//            Text(value)
//                .foregroundColor(.gray)
//        }
//    }

    func format(_ date: Date?) -> String {
        guard let date = date else { return "—" }

        let calendar = Calendar.current

        // 1. Hoje
        if calendar.isDateInToday(date) {
            return "Hoje"
        }

        // 2. Ontem
        if calendar.isDateInYesterday(date) {
            return "Ontem"
        }

        // 3. Últimos 7 dias → relative string
        if let days = calendar.dateComponents([.day], from: date, to: Date())
            .day,
            days < 7
        {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .short
            formatter.locale = Locale(identifier: "pt_BR")
            return formatter.localizedString(for: date, relativeTo: Date())
        }

        // 4. Caso contrário → dd/MM/yyyy
        let df = DateFormatter()
        df.locale = Locale(identifier: "pt_BR")
        df.dateFormat = "dd/MM/yyyy"
        return df.string(from: date)
    }

}
