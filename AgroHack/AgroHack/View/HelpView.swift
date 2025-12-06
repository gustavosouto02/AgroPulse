//
//  HelpView.swift
//  AgroHack
//
//  Created on 05/12/25.
//

import SwiftUI

struct HelpView: View {
    let helpCategories: [HelpCategory] = [
        HelpCategory(name: "Solo", imageName: "solo"),
        HelpCategory(name: "Folhas", imageName: "folhas"),
        HelpCategory(name: "Caule", imageName: "caule"),
        HelpCategory(name: "Frutos", imageName: "frutos"),
        HelpCategory(name: "Pragas", imageName: "pragas"),
        HelpCategory(name: "Raízes", imageName: "raizes"),
        HelpCategory(name: "Sementes", imageName: "sementes"),
        HelpCategory(name: "Flor", imageName: "flor")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header
                        HeaderHelpView()
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                        
                        // Grid de categorias
                        HelpCategoriesGrid(categories: helpCategories)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                    }
                }
            }
        }
    }
}

// MARK: - Header
struct HeaderHelpView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ajuda")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.primary)
            
            Text("Tire dúvidas sobre tudo o que envolve sua plantação")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .lineSpacing(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Help Category Model
struct HelpCategory: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
}

// MARK: - Categories Grid
struct HelpCategoriesGrid: View {
    let categories: [HelpCategory]
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(categories) { category in
                HelpCategoryCard(category: category)
            }
        }
    }
}

// MARK: - Category Card
struct HelpCategoryCard: View {
    let category: HelpCategory
    
    var body: some View {
        Button(action: {
            // Caminho vazio por enquanto
        }) {
            VStack(spacing: 16) {
                // Imagem
                Image(category.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                
                // Label
                Text(category.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .padding(.vertical, 20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
#Preview {
    HelpView()
}

