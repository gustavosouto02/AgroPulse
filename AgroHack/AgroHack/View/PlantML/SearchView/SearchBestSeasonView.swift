//
//  SearchBestSeasonView.swift
//  AgroHack
//
//  Created by Filipi Romão on 06/12/25.
//

import SwiftUI

struct SearchBestSeasonView: View {
    @StateObject var bestSeasonViewModel = SearchBestSeasonViewModel()
    @State var bestSeasons: [BestSeasonModel] = []
    @State var bestSeason: BestSeasonModel?
    @Environment(\.dismiss) private var dismiss
    
    var cicleTypes: [GroupCicleType] = GroupCicleType.allCases
    var riscoOptions: [Int] = [20, 30, 40]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                HeaderSearch()
                
                // Instrução
                Text("Preencha os dados abaixo")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                
                // Primeiro Card - Código IBGE e Cultura
                CodigoECulturaCard(vm: bestSeasonViewModel)
                
                // Segundo Card - Risco máximo e Tipo de grão
                VStack(spacing: 0) {
                    // Campo Risco máximo aceito
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Risco máximo aceito")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(Color("colorPrimal"))
                        
                        Menu {
                            ForEach(riscoOptions, id: \.self) { risco in
                                Button("\(risco)") {
                                    bestSeasonViewModel.riscoMaximo = risco
                                }
                            }
                        } label: {
                            HStack {
                                Text(bestSeasonViewModel.riscoMaximo == 0 ? "" : "\(bestSeasonViewModel.riscoMaximo)")
                                    .foregroundColor(bestSeasonViewModel.riscoMaximo == 0 ? .gray.opacity(0.6) : .black)
                                Spacer()
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            .padding(.bottom, 4)
                        }
                        
                        Divider()
                            .background(Color.gray.opacity(0.3))
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    // Campo Tipo de grão
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tipo de grão")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(Color("colorPrimal"))
                        
                        Menu {
                            ForEach(cicleTypes, id: \.self) { ciclo in
                                Button(ciclo.rawValue) {
                                    bestSeasonViewModel.cicloDoGrao = ciclo
                                }
                            }
                        } label: {
                            HStack {
                                Text(bestSeasonViewModel.cicloDoGrao.rawValue)
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            .padding(.bottom, 4)
                        }
                        
                        Divider()
                            .background(Color.gray.opacity(0.3))
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                }
                .background(Color.white)
                .cornerRadius(18)
                .shadow(color: Color.black.opacity(0.05), radius: 5, y: 3)
                .padding(.horizontal)
                
                // Botão de ação
                NavigationLink(destination: ResultSeasonView(bestSeasonviewModel: bestSeasonViewModel), label: {
                    HStack{
                        Text("Calcular melhor opção")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color("colorPrimal"))
                            .cornerRadius(30)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                })
                
            }
        }
        .background(Color(.systemGray6))
       // .navigationTitle("Início")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(8)
                }
            }
        }
        .toolbarBackground(Color("colorPrimal"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        SearchBestSeasonView()
    }
}
