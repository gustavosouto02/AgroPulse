//
//  CareSection.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 04/12/25.
//

import SwiftUI

struct CareSection: View {

    let plant: PlantModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Manejo e Cuidados")
                .font(.headline)

            info(
                icon: "drop.fill",
                title: "Última rega",
                value: format(plant.ultimaRega)
            )

            info(
                icon: "apple.meditate.circle.fill",
                title: "Última adubação",
                value: format(plant.ultimaAdubacao)
            )

            info(
                icon: "allergens.fill",
                title: "Última praga",
                value: format(plant.ultimaPraga)
            )

            info(
                icon: "cross.vial.fill",
                title: "Tratamento",
                value: format(plant.ultimoTratamento)
            )
        }
        .padding()
        .background(.white)
        .cornerRadius(12)
        .shadow(radius: 3)
        .padding(.horizontal)
    }

    func info(icon: String, title: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.green)
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
        }
    }

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
        if let days = calendar.dateComponents([.day], from: date, to: Date()).day,
           days < 7 {
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
