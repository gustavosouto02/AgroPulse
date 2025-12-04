//
//  AgroHackApp.swift
//  AgroHack
//
//  Created by Joao pedro Leonel on 03/12/25.
//

import SwiftUI

@main
struct AgroHackApp: App {
    @StateObject var chatVm = ChatBotViewModel(manager: ManagerChat())
    @StateObject private var appState = AppState()
    var body: some Scene {
        WindowGroup {
//            ContentView()
            ChatBotView(chatVm: chatVm)
        }
    }
}
