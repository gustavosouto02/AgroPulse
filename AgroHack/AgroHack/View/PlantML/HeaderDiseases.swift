//
//  HeaderDiseases.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 06/12/25.
//

import SwiftUI

struct HeaderDiseases: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text("Dr. Planta")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.primary)
            
            Text("Identifique as doenças e proteja sua planta!")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .lineSpacing(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    HeaderDiseases()
}
