//
//  HomeView.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 04/12/25.
//

import SwiftUI

struct HomeView: View {

    // Altura do Header (ajuste conforme o layout)
    let headerHeight: CGFloat = 260

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {

                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(alignment: .leading) {
                        // HEADER FIXO COMO FUNDO
                        HeaderHome()
                            .ignoresSafeArea(edges: .top)
                            .padding(.top, -70)

                        // WEATHER CARD (agora dentro do scroll)
                        Image("WeatherCard")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal)
                            .padding(.top, -100)

                        // Plantações Atuais
                        CurrentCropsSection()
                            .padding()
                    }

                }

                // FAB
                FloatingAddButton()
                    .padding(.trailing, 20)
                    .padding(.bottom, 10)
                    .frame(maxHeight: .infinity, alignment: .bottomTrailing)
            }.background(Color.secondary.opacity(0.2))
        }
    }
}

#Preview {
    HomeView()
}
