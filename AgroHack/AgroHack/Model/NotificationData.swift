//
//  NotificationData.swift
//  AgroHack
//
//  Created on 05/12/25.
//

import Foundation

struct NotificationData: Identifiable {
    let id: UUID
    let plantName: String
    let plantImage: String
    let message: String
    let timestamp: Date
    
    init(id: UUID = UUID(), plantName: String, plantImage: String, message: String, timestamp: Date) {
        self.id = id
        self.plantName = plantName
        self.plantImage = plantImage
        self.message = message
        self.timestamp = timestamp
    }
    
    // Computed property para calcular tempo relativo
    var timeAgo: String {
        let now = Date()
        let difference = Calendar.current.dateComponents([.hour, .day], from: timestamp, to: now)
        
        if let days = difference.day, days > 0 {
            return "\(days)d"
        } else if let hours = difference.hour, hours > 0 {
            return "\(hours)h"
        } else {
            return "Agora"
        }
    }
    
    // Categoriza a notificação por período
    enum TimePeriod {
        case today
        case last7Days
        case last30Days
        
        var title: String {
            switch self {
            case .today:
                return "Ontem"
            case .last7Days:
                return "Últimos 7 dias"
            case .last30Days:
                return "Últimos 30 dias"
            }
        }
    }
    
    var period: TimePeriod {
        let now = Date()
        let difference = Calendar.current.dateComponents([.day], from: timestamp, to: now)
        
        if let days = difference.day {
            if days <= 1 {
                return .today
            } else if days <= 7 {
                return .last7Days
            } else {
                return .last30Days
            }
        }
        return .last30Days
    }
}

// MARK: - Mock Data
extension NotificationData {
    static var mockNotifications: [NotificationData] {
        let now = Date()
        
        return [
            // Ontem (12 horas atrás)
            NotificationData(
                plantName: "Café",
                plantImage: "cafe",
                message: "Sua planta está há 3 dias sem irrigação.",
                timestamp: now.addingTimeInterval(-43200) // 12 horas
            ),
            
            // Últimos 7 dias
            NotificationData(
                plantName: "Alface",
                plantImage: "alface",
                message: "Há risco de granizo. Proteja suas alfaces.",
                timestamp: now.addingTimeInterval(-86400 * 3) // 3 dias
            ),
            
            NotificationData(
                plantName: "Tomate",
                plantImage: "tomate",
                message: "Seu tomate deve atingir ponto de colheita em 5 dias.",
                timestamp: now.addingTimeInterval(-86400 * 5) // 5 dias
            ),
            
            NotificationData(
                plantName: "Trigo",
                plantImage: "trigo",
                message: "Tempo seco aumentando risco de pragas.",
                timestamp: now.addingTimeInterval(-86400 * 6) // 6 dias
            ),
            
            // Últimos 30 dias
            NotificationData(
                plantName: "Café",
                plantImage: "cafe",
                message: "Sua planta está há 3 dias sem irrigação.",
                timestamp: now.addingTimeInterval(-86400 * 12) // 12 dias
            ),
            
            NotificationData(
                plantName: "Alface",
                plantImage: "alface",
                message: "Há risco de granizo. Proteja suas alfaces.",
                timestamp: now.addingTimeInterval(-86400 * 12) // 12 dias
            ),
            
            NotificationData(
                plantName: "Milho",
                plantImage: "milho",
                message: "Nível de nutrientes baixo. Considere adubação.",
                timestamp: now.addingTimeInterval(-86400 * 15) // 15 dias
            ),
            
            NotificationData(
                plantName: "Pimenta",
                plantImage: "pimenta",
                message: "Temperatura ideal para crescimento detectada.",
                timestamp: now.addingTimeInterval(-86400 * 20) // 20 dias
            ),
            
            NotificationData(
                plantName: "Trigo",
                plantImage: "trigo",
                message: "Previsão de chuvas fortes nos próximos dias.",
                timestamp: now.addingTimeInterval(-86400 * 25) // 25 dias
            )
        ]
    }
}


