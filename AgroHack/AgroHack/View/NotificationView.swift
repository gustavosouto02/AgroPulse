//
//  NotificationView.swift
//  AgroHack
//
//  Created on 05/12/25.
//

import SwiftUI

struct NotificationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var notifications: [NotificationData] = NotificationData.mockNotifications
    
    // Agrupa notificações por período
    private var groupedNotifications: [(period: NotificationData.TimePeriod, notifications: [NotificationData])] {
        let periods: [NotificationData.TimePeriod] = [.today, .last7Days, .last30Days]
        
        return periods.compactMap { period in
            let filtered = notifications.filter { $0.period == period }
            return filtered.isEmpty ? nil : (period, filtered)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Background
                Color("colorSecondary")
                    .opacity(0.1)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header customizado
                    HeaderNotification(onBack: {
                        dismiss()
                    })
                    .padding(.bottom, 20)
                    
                    // Lista de notificações
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 24) {
                            ForEach(groupedNotifications, id: \.period.title) { group in
                                VStack(alignment: .leading, spacing: 12) {
                                    // Título da seção
                                    Text(group.period.title)
                                        .font(.title3)
                                        .bold()
                                        .foregroundStyle(.primary)
                                        .padding(.horizontal, 20)
                                    
                                    // Notificações da seção
                                    ForEach(group.notifications) { notification in
                                        NotificationCard(notification: notification)
                                            .padding(.horizontal, 20)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 10)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Header Component
struct HeaderNotification: View {
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: onBack) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Início")
                            .font(.system(size: 16))
                    }
                    .foregroundStyle(.primary)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 50)
            .padding(.bottom, 10)
            
            // Título
            HStack {
                Text("Notificações")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.primary)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
        .background(Color("colorSecondary").opacity(0.05))
    }
}

// MARK: - Notification Card Component
struct NotificationCard: View {
    let notification: NotificationData
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Imagem da planta
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 60, height: 60)
                    .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                
                Image(notification.plantImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            }
            
            // Conteúdo da notificação
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(notification.plantName)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Text(notification.timeAgo)
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }
                
                Text(notification.message)
                    .font(.system(size: 15))
                    .foregroundStyle(.primary)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color("colorPrimal").opacity(0.15), lineWidth: 1)
        )
    }
}

// MARK: - Preview
#Preview {
    NotificationView()
}


