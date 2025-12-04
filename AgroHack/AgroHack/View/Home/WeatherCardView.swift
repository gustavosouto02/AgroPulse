//
//  WeatherCardView.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 04/12/25.
//

import SwiftUI

struct WeatherCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Topo (Localização e Temperatura)
            HStack {
                Image(systemName: "mappin.circle.fill")
                Text("Brumadinho, DF")
                    .font(.subheadline)
                    .bold()
                Spacer()
            }
            
            // Temperatura e Sol
            HStack(alignment: .top) {
                Text("+17°")
                    .font(.system(size: 48, weight: .light))
                
                VStack(alignment: .leading) {
                    Text("MÁX: 25°C")
                    Text("MÍN: 15°C")
                }
                .font(.caption)
                .foregroundColor(.gray)
                
                Spacer()
                
                Image(systemName: "sun.max.fill")
                    .font(.largeTitle)
                    .foregroundColor(.yellow)
            }
            
            // Detalhes do Clima (Umidade, Visibilidade, etc.)
            HStack {
                WeatherDetail(title: "Umidade", value: "56%")
                Spacer()
                WeatherDetail(title: "Visibilidade", value: "17 km")
                Spacer()
                WeatherDetail(title: "Índice UV", value: "8")
                Spacer()
                WeatherDetail(title: "Chuva", value: "5 mm")
            }
            
            // Gráfico Simplificado (Nascer/Pôr do sol)
            SimplifiedTimeline()
            
        }
        .padding()
        .background(Color.secondary) // Fundo do cartão de clima
        .cornerRadius(15)
    }
}

// Componente auxiliar para os detalhes (Umidade, etc.)
struct WeatherDetail: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption2)
                .foregroundColor(.gray)
            Text(value)
                .font(.subheadline)
                .bold()
        }
    }
}

// Componente auxiliar para a linha do tempo
struct SimplifiedTimeline: View {
    var body: some View {
        VStack {
            HStack {
                Text("5:32 am")
                    .font(.caption2)
                Spacer()
                Text("8:32 pm")
                    .font(.caption2)
            }
            
            // Linha com o ponto amarelo simulando a posição do sol
            TimelineView(color: Color("colorPrimal"), pointPosition: 0.5)
                .frame(height: 5)
        }
    }
}

// Simulação da Linha do Tempo (como um ProgressBar)
struct TimelineView: View {
    var color: Color
    var pointPosition: CGFloat // 0.0 a 1.0

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let xPosition = width * pointPosition
            
            ZStack(alignment: .leading) {
                // Linha de Fundo
                Capsule()
                    .fill(Color(.systemGray3))
                    .frame(height: 5)
                
                // Ponto Amarelo
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 12, height: 12)
                    .offset(x: xPosition - 6) // Centraliza o ponto
            }
        }
    }
}

#Preview {
    WeatherCardView()
}
