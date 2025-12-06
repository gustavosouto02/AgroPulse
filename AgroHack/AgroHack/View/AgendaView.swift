//
//  AgendaView.swift
//  AgroHack
//
//  Created on 05/12/25.
//

import SwiftUI

struct AgendaView: View {
    @State private var selectedDate: Date = {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2025
        components.month = 12
        components.day = 8
        return calendar.date(from: components) ?? Date()
    }()
    @State private var tasks: [AgendaTask] = AgendaTask.mockTasks
    @State private var calendarEvents: [CalendarEvent] = []
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "MMMM 'de' yyyy"
        return formatter
    }()
    
    private let weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "EEE"
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header
                        HeaderAgendaView()
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                        
                        // Próximos afazeres
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Próximos afazeres")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.primary)
                                .padding(.horizontal, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(tasks) { task in
                                        TaskCardView(task: task)
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // Calendário
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Calendário")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.primary)
                                .padding(.horizontal, 20)
                            
                            CalendarView(
                                selectedDate: $selectedDate,
                                calendarEvents: calendarEvents
                            )
                            .padding(.horizontal, 20)
                        }
                        .padding(.bottom, 100)
                    }
                }
                .background(Color(.systemGray6))
                
                // FAB
                FloatingActionButton()
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
            }
        }
        .onAppear {
            calendarEvents = CalendarEvent.generateEventsForMonth(selectedDate)
        }
        .onChange(of: selectedDate) { newDate in
            calendarEvents = CalendarEvent.generateEventsForMonth(newDate)
        }
    }
}

// MARK: - Header
struct HeaderAgendaView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Agenda")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.primary)
            
            Text("Próximos afazeres")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Task Card
struct TaskCardView: View {
    let task: AgendaTask
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                // Imagem da planta
                Image(task.plantImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.plantName)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(task.formattedDate)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Botão de ação
            HStack(spacing: 0) {
                // Barra verde vertical
                Rectangle()
                    .fill(Color("colorPrimal"))
                    .frame(width: 4)
                
                Text(task.action)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color("colorPrimal"))
                    .padding(.leading, 12)
                    .padding(.vertical, 10)
                
                Spacer()
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color("colorPrimal").opacity(0.1))
            )
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        .frame(width: 280)
    }
}

// MARK: - Calendar View
struct CalendarView: View {
    @Binding var selectedDate: Date
    let calendarEvents: [CalendarEvent]
    
    private let calendar = Calendar.current
    private let weekdays = ["DOM.", "SEG.", "TER.", "QUA.", "QUI.", "SEX.", "SÁB."]
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "MMMM 'de' yyyy"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 16) {
            // Header do calendário (mês/ano e navegação)
            HStack {
                HStack(spacing: 8) {
                    Text(dateFormatter.string(from: selectedDate).capitalized)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 16) {
                    Button(action: {
                        withAnimation {
                            selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    
                    Button(action: {
                        withAnimation {
                            selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(12)
            
            // Dias da semana
            HStack(spacing: 0) {
                ForEach(weekdays, id: \.self) { weekday in
                    Text(weekday)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 8)
            
            // Grid do calendário
            CalendarGridView(
                selectedDate: $selectedDate,
                calendarEvents: calendarEvents
            )
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Calendar Grid
struct CalendarGridView: View {
    @Binding var selectedDate: Date
    let calendarEvents: [CalendarEvent]
    
    private let calendar = Calendar.current
    
    private var monthDays: [Date?] {
        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate)),
              let monthRange = calendar.range(of: .day, in: .month, for: monthStart) else {
            return []
        }
        
        var days: [Date?] = []
        
        // Primeiro dia do mês
        let firstDay = monthStart
        var firstWeekday = calendar.component(.weekday, from: firstDay)
        
        // Ajuste: No iOS, domingo = 1, segunda = 2, etc.
        // Queremos domingo = 0 para o offset
        firstWeekday = firstWeekday - 1
        if firstWeekday < 0 {
            firstWeekday = 6
        }
        
        // Espaços vazios antes do primeiro dia
        for _ in 0..<firstWeekday {
            days.append(nil)
        }
        
        // Dias do mês
        for day in monthRange {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func hasEvent(for date: Date) -> Bool {
        calendarEvents.contains { event in
            calendar.isDate(event.date, inSameDayAs: date) && event.hasEvent
        }
    }
    
    private func isSelectedDate(_ date: Date) -> Bool {
        calendar.isDate(date, inSameDayAs: selectedDate)
    }
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 8) {
            ForEach(Array(monthDays.enumerated()), id: \.offset) { index, date in
                if let date = date {
                    CalendarDayView(
                        date: date,
                        isSelected: isSelectedDate(date),
                        hasEvent: hasEvent(for: date)
                    )
                    .onTapGesture {
                        withAnimation {
                            selectedDate = date
                        }
                    }
                } else {
                    Color.clear
                        .frame(height: 40)
                }
            }
        }
    }
}

// MARK: - Calendar Day
struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let hasEvent: Bool
    
    private let calendar = Calendar.current
    
    private var dayNumber: Int {
        calendar.component(.day, from: date)
    }
    
    var body: some View {
        ZStack {
            // Círculo de seleção
            if isSelected {
                Circle()
                    .fill(Color("colorPrimal"))
                    .frame(width: 36, height: 36)
            }
            
            // Número do dia
            Text("\(dayNumber)")
                .font(.system(size: 16, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .white : .primary)
            
            // Ponto verde para eventos
            if hasEvent {
                VStack {
                    Spacer()
                    Circle()
                        .fill(Color("colorPrimal"))
                        .frame(width: 6, height: 6)
                        .offset(y: -4)
                }
            }
        }
        .frame(height: 40)
    }
}

// MARK: - Floating Action Button
struct FloatingActionButton: View {
    var body: some View {
        Button(action: {
            // Ação do FAB
        }) {
            ZStack {
                Circle()
                    .fill(Color("colorPrimal"))
                    .frame(width: 56, height: 56)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    AgendaView()
}

