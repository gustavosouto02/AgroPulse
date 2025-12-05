//
//  LifeCycleSection.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 04/12/25.
//

import SwiftUI


import SwiftUI

struct LifeCycleSection: View {
    
    let estagio: String
    
    let steps: [(name: String, date: String)] = [
        ("Germinação", "12/04"),
        ("Crescimento", ""),
        ("Floração", ""),
        ("Colheita", "25/05")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Header
            HStack {
                Text("Ciclo de Vida")
                    .font(.headline)
                
                Spacer()
                
                Text("120 dias")
                    .font(.headline)
                    .foregroundColor(Color("colorPrimal"))
            }
            
            // 🔥 Aqui você usa o componente reutilizável
            GrowthProgressView(
                steps: steps.map { $0.name },
                dates: steps.map { $0.date },
                current: estagio
            )
            .padding(.vertical, 10)
            
        }
        .padding()
        .background(.white)
        .cornerRadius(12)
        .shadow(radius: 3)
        .padding(.horizontal)
    }
}
