//
//  AgroHackApp.swift
//  AgroHack
//
//  Created by Joao pedro Leonel on 03/12/25.
//

import SwiftUI
import SwiftData

@main
struct AgroHackApp: App {
//    @StateObject var chatVm = ChatBotViewModel(manager: ManagerChat())
    @StateObject private var appState = AppState()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: PlantModel.self)
        }
    }
}
