//
//  CodigoECulturaCard.swift
//  AgroHack
//
//  Created by Filipi Romão on 07/12/25.
//

import SwiftUI

struct CodigoECulturaCard: View {
    @ObservedObject var vm: SearchBestSeasonViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Código IBGE")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Color("colorPrimal"))

                TextField("", text: $vm.codigoIBGE)
                    .keyboardType(.decimalPad)
                    .padding(.bottom, 4)

                Divider().background(Color.gray.opacity(0.3))
            }
            .padding([.horizontal, .top], 16)

            VStack(alignment: .leading, spacing: 8) {
                Text("Cultura")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Color("colorPrimal"))

                TextField("Informe a cultura da plantação", text: $vm.cultura)
                    .padding(.bottom, 4)

                Divider().background(Color.gray.opacity(0.3))
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)

            Menu {
                ForEach(vm.tiposSolo, id: \.self) { solo in
                    Button(solo.rawValue) { vm.tipoSolo = solo }
                }
            } label: {
                HStack {
                    Text("Tipo de solo: \(vm.tipoSolo.rawValue)")
                    Spacer()
                }
            }
            .padding(16)
        }
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
        .padding(.horizontal)
    }
}



