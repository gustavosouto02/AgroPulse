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

            CareRow(
                icon: "drop.fill",
                color: .blue,
                label: "Última rega",
                date: Binding(get: { plant.ultimaRega ?? Date() }, set: { plant.ultimaRega = $0 })
            )

            CareRow(
                icon: "apple.meditate.circle.fill",
                color: .brown,
                label: "Última adubação",
                date: Binding(get: { plant.ultimaAdubacao ?? Date() }, set: { plant.ultimaAdubacao = $0 })
            )

            CareRow(
                icon: "allergens.fill",
                color: .green,
                label: "Última praga",
                date: Binding(get: { plant.ultimaPraga ?? Date() }, set: { plant.ultimaPraga = $0 })
            )

            CareRow(
                icon: "cross.vial.fill",
                color: .blue,
                label: "Último tratamento",
                date: Binding(get: { plant.ultimoTratamento ?? Date() }, set: { plant.ultimoTratamento = $0 })
            )
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
        .padding(.horizontal)
        .environment(\.locale, Locale(identifier: "pt_BR"))
    }
}

// MARK: - Subview Reutilizável
struct CareRow: View {
    var icon: String
    var color: Color
    var label: String
    @Binding var date: Date

    var body: some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(color)
            
            Text(label)
                .font(.body)
                .lineLimit(1)
            
            Spacer()
            
            DatePicker("", selection: $date, displayedComponents: .date)
                .datePickerStyle(.compact)
                .labelsHidden()
                .scaleEffect(0.9)
                .padding(.trailing, -8)
        }
    }
}
