//
//  AgendaData.swift
//  AgroHack
//
//  Created on 05/12/25.
//

import Foundation

struct AgendaTask: Identifiable {
    let id: UUID
    let plantName: String
    let plantImage: String
    let date: Date
    let action: String
    
    init(id: UUID = UUID(), plantName: String, plantImage: String, date: Date, action: String) {
        self.id = id
        self.plantName = plantName
        self.plantImage = plantImage
        self.date = date
        self.action = action
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "EEEE, dd/MM"
        return formatter.string(from: date).uppercased()
    }
}

struct CalendarEvent: Identifiable {
    let id: UUID
    let date: Date
    let hasEvent: Bool
    
    init(id: UUID = UUID(), date: Date, hasEvent: Bool = false) {
        self.id = id
        self.date = date
        self.hasEvent = hasEvent
    }
}

// MARK: - Mock Data
extension AgendaTask {
    static var mockTasks: [AgendaTask] {
        let calendar = Calendar.current
        
        // Segunda-feira, 08/12/2025
        var mondayComponents = DateComponents()
        mondayComponents.year = 2025
        mondayComponents.month = 12
        mondayComponents.day = 8
        let mondayDate = calendar.date(from: mondayComponents) ?? Date()
        
        // Terça-feira, 09/12/2025
        var tuesdayComponents = DateComponents()
        tuesdayComponents.year = 2025
        tuesdayComponents.month = 12
        tuesdayComponents.day = 9
        let tuesdayDate = calendar.date(from: tuesdayComponents) ?? Date()
        
        return [
            AgendaTask(
                plantName: "Café",
                plantImage: "cafe",
                date: mondayDate,
                action: "Regar toda a safra"
            ),
            AgendaTask(
                plantName: "Pimenta",
                plantImage: "pimenta",
                date: tuesdayDate,
                action: "Aplicar medicação"
            )
        ]
    }
}

extension CalendarEvent {
    static func generateEventsForMonth(_ date: Date) -> [CalendarEvent] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        guard let startOfMonth = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: startOfMonth) else {
            return []
        }
        
        var events: [CalendarEvent] = []
        
        // Dias com eventos (4, 6, 9, 12, 8 é destacado)
        let eventDays: Set<Int> = [4, 6, 8, 9, 12]
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                events.append(CalendarEvent(
                    date: date,
                    hasEvent: eventDays.contains(day)
                ))
            }
        }
        
        return events
    }
}

