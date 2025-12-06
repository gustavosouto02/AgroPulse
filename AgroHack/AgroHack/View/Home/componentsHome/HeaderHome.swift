//
//  HeaderHome.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 04/12/25.
//

//
//  HeaderHome.swift
//  AgroHack
//
//  Created by Gustavo Souto Pereira on 04/12/25.
//

import SwiftUI

struct HeaderHome: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Spacer()
                .frame(height: 50)
            
            HStack(alignment: .center) {
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Olá, Bom Dia")
                        .font(.title2)
                        .bold()
                    Text("Domingo, 07 Dez 2025")
                        .font(.caption)
                }
                .foregroundStyle(.white)
                
                Spacer()
                
                // MUDANÇA AQUI: Usamos 'value' com uma String em vez de 'destination'
                NavigationLink(value: "NotificationView") {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 44, height: 44)
                            .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)

                        Image(systemName: "bell.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.white)
                    }
                    .contentShape(Circle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 20)
            
            SearchBarView()
                .padding(.horizontal, 20)
            
            Spacer()
                .frame(height: 120)

            
        }
        .frame(maxWidth: .infinity)
        .background(Color("colorPrimal"))
        .clipShape(RoundedRectangle(cornerRadius: 60, style: .continuous))
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    HeaderHome()
}
