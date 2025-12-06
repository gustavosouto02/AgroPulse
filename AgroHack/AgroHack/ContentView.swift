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
                    
                
                // 2. Outras Abas (Placeholders)
                Text("Agenda")
                    .tabItem {
                        Label("Agenda", systemImage: "calendar")
                    }
                
                ColorTestView()
                    .tabItem {
                        Label("IA de foto", systemImage: "message")
                    }
                   
                
                Text("Transporte")
                    .tabItem {
                        Label("Transporte", systemImage: "truck.box.fill")
                    }
            }
            .tint(Color("colorPrimal")) // Cor dos ícones ativos na TabView
            .preferredColorScheme(.light)

        }
    }



