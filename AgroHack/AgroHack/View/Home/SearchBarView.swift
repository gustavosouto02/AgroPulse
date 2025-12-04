//
//  SearchBarView.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 04/12/25.
//

import SwiftUI

struct SearchBarView: View {
    @State private var searchText: String = ""
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Pesquisar alimento...", text: $searchText)
        }
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(100)
    }
}

#Preview {
    SearchBarView()
}
