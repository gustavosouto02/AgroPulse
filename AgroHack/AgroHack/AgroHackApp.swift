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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: PlantModel.self)
        }
    }
}
