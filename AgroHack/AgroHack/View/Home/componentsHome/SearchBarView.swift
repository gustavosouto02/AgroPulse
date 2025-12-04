//
//  SearchBarView.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 04/12/25.
//

import SwiftUI

struct SearchBarView: View {
    @State private var searchText: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 18, height: 18)
                .foregroundStyle(.white.opacity(0.9))

            ZStack(alignment: .leading) {
                // Placeholder branco quando o campo está vazio
                if searchText.isEmpty {
                    Text("Pesquisar alimento...")
                        .foregroundStyle(.white.opacity(0.7))
                }

                TextField("", text: $searchText)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .foregroundStyle(.white)
                    .focused($isFocused)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 100, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
        )
        .contentShape(RoundedRectangle(cornerRadius: 100, style: .continuous))
        .onTapGesture {
            isFocused = false
        }
    }
}

#Preview {
    SearchBarView()
}
