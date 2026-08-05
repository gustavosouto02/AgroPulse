//
//  HeaderSearch.swift
//  AgroPulse
//
//  Created by Filipi Romão on 07/12/25.
//

import SwiftUI

struct HeaderSearch: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Sua melhor época")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            
            Text("Entenda o período ideal para ter mais sucesso na sua plantação")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

#Preview {
    HeaderSearch()
}
