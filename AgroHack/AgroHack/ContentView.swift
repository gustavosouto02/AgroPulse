//
//  ContentView.swift
//  AgroHack
//
//  Created by Joao pedro Leonel on 03/12/25.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {

            TabView {
                // 1. Aba Principal (HomeView)
                HomeView()
                    .tabItem {
                        Label("Início", systemImage: "house.fill")
                    }
                    
                
                // 2. Agenda
                AgendaView()
                    .tabItem {
                        Label("Agenda", systemImage: "calendar")
                    }
                
                // 3. Ajuda
                HelpView()
                    .tabItem {
                        Label("Ajuda", systemImage: "questionmark.circle")
                    }
            }
            .tint(Color("colorPrimal")) // Cor dos ícones ativos na TabView
            .preferredColorScheme(.light)

        }
    }



