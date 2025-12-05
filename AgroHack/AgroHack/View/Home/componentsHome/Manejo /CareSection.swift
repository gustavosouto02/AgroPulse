//
//  CareSection.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 04/12/25.
//

import SwiftUI

struct CareSection: View {
    
    let plant: PlantModel
    
    @State private var ultimaRega: Date
    @State private var ultimaAdubacao: Date
    @State private var ultimaPraga: Date
    @State private var ultimoTratamento: Date
    
    init(plant: PlantModel) {
        self.plant = plant
        _ultimaRega = State(initialValue: plant.ultimaRega ?? Date())
        _ultimaAdubacao = State(initialValue: plant.ultimaAdubacao ?? Date())
        _ultimaPraga = State(initialValue: plant.ultimaPraga ?? Date())
        _ultimoTratamento = State(initialValue: plant.ultimoTratamento ?? Date())
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Manejo e Cuidados")
                .font(.headline)
            
            info(
                icon: "drop.fill",
                title: "Última rega",
                date: $ultimaRega
            )
            
            info(
                icon: "apple.meditate.circle.fill",
                title: "Última adubação",
                date: $ultimaAdubacao
            )
            
            info(
                icon: "allergens.fill",
                title: "Última praga",
                date: $ultimaPraga
            )
            
            info(
                icon: "cross.vial.fill",
                title: "Tratamento",
                date: $ultimoTratamento
            )
        }
        .padding()
        .background(.white)
        .cornerRadius(12)
        .shadow(radius: 3)
        .padding(.horizontal)
    }
    
    func info(icon: String, title: String, date: Binding<Date>) -> some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.green)
            Text(title)
            Spacer()
            DatePicker("", selection: date, displayedComponents: .date)
                .datePickerStyle(.compact)
                .labelsHidden()
                .environment(\.locale, Locale(identifier: "pt_BR"))
                .frame(width: 140, alignment: .trailing)
                //.padding(.horizontal)
        }
    }
}


