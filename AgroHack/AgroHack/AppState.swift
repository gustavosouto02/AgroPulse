//
//  AppState.swift
//  AgroHack
//
//  Created by Filipi Romão on 04/12/25.
//

import Foundation
import SwiftUI
import Combine

class AppState: ObservableObject {
    
    @Published var selectedTab: Int = 0
    @Published var jobDescriptionToPaste: String? = nil // O dado a ser enviado

}
