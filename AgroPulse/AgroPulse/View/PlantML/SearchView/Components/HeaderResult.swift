//
//  HeaderResult.swift
//  AgroPulse
//
//  Created by Gustavo Souto Pereira on 07/12/25.
//

import Foundation
import SwiftUI

struct HeaderResult: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Resultado")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            
            Text("O período ideal para ter mais sucesso na sua plantação")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

#Preview {
    HeaderResult()
}
