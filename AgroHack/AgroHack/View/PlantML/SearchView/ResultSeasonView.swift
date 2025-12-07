//
//  ResultSeasonView.swift
//  AgroHack
//
//  Created by Filipi Romão on 07/12/25.
//
import Combine
import SwiftUI

struct ResultSeasonView: View {
    @ObservedObject var bestSeasonviewModel: SearchBestSeasonViewModel
    @State var bestSeasons: [BestSeasonModel] = []
    @State var bestSeason: BestSeasonModel?
    @Environment(\.dismiss) var dismiss
    
    private func formatDate(day: Int, month: Int, year: Int) -> String {
            let monthNames = ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"]
            
            let monthIndex = month - 1
            let monthString = (monthIndex >= 0 && monthIndex < 12) ? monthNames[monthIndex] : "Mês Inválido"
            
            return "\(day) de \(monthString) de \(year)"
        }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.systemGray6).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    HeaderResult()
                    
                    Text("Melhor opção:")
                        .font(.title3.bold())
                        .foregroundColor(.black)
                        .padding(.horizontal)
                    
                    if let result = bestSeason {
                        
                        // 3. CARD ÚNICO DE DATAS (Início e Fim)
                        VStack(alignment: .leading, spacing: 16) {
                            
                            // --- Campo INÍCIO ---
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Início")
                                    .font(.subheadline)
                                
                                Text(formatDate(day: result.diaIni, month: result.mesIni, year: result.safraIni))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .font(.headline)
                                    .foregroundStyle(Color("colorPrimal")) // Texto verde
                                    .background(Color(.systemGray6)) // Fundo cinza dentro do card branco
                                    .cornerRadius(12)
                            }
                            
                            // --- Campo FIM ---
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Fim")
                                    .font(.subheadline)
                                
                                Text(formatDate(day: result.diaFim, month: result.mesFim, year: result.safraFim))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .font(.headline)
                                    .foregroundStyle(Color("colorPrimal")) // Texto verde
                                    .background(Color(.systemGray6)) // Fundo cinza dentro do card branco
                                    .cornerRadius(12)
                            }
                        }
                        .padding(20) // Padding interno para o card branco
                        .background(Color.white) // O cartão principal é branco
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3) // Sombra suave
                        .padding(.horizontal)
                        
                        // 4. CARD DE MENSAGEM
                        Text("Essa foi a época que tem mais chances de obter sucesso na plantação com base nas informações do seu local e da sua cultura escolhida")
                            .font(.headline)
                            .multilineTextAlignment(.leading)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color("colorPrimal")) // Texto verde
                            .background(Color.white) // Fundo branco
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3) // Sombra suave
                            .padding(.horizontal)
                            .padding(.top, 5) // Pequeno espaço entre os cards
                        
                        Spacer() // Empurra o conteúdo para cima
                        
                    } else {
                        ProgressView("Buscando a melhor época...").padding(.top, 50)
                        Spacer()
                    }
                } // Fim VStack de Conteúdo
                .padding(.bottom, 120) // Espaço para o botão flutuante
                
            } // Fim ScrollView
        } // Fim ZStack
        .onAppear {
            Task {
                do {
                    bestSeason = try await bestSeasonviewModel.getBestSeason()
                } catch {
                    print("Erro ao buscar melhor safra:", error)
                }
            }
        }
        // Configurações de navegação (fora do ZStack)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
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
    
