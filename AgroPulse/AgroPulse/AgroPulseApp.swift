//
//  AgroPulseApp.swift
//  AgroPulse
//
//  Created by Joao pedro Leonel on 03/12/25.
//

import SwiftUI
import SwiftData

@main
struct AgroPulseApp: App {
    @StateObject var chatVm = ChatBotViewModel()
    @StateObject private var appState = AppState()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: PlantModel.self)
                .environmentObject(chatVm)

        }
    }
}
