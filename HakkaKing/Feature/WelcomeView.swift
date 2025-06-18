

//
//  ContentView.swift
//  WangHakka
//
//  Created by Angel on 16/06/25.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0.67, green: 0.9, blue: 0.95), location: 0.00),
                        Gradient.Stop(color: Color(red: 1, green: 0.98, blue: 0.96), location: 0.89),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    VStack {
                        Text("Selamat Datang!")
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.primary)
                            .fontWeight(.semibold)
                            .padding(.top, 45)
                        
                        Text("Hai, aku Wang, dimsum pintar asal Singkawang yang akan menemani kamu belajar pelafalan bahasa Hakka-Indonesia.")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 16))
                            .foregroundColor(.primary)
                            .padding(.top, 15)
                        Spacer()
                        NavigationLink(destination: ContentView()) {
                            Text("Yuk mulai!")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(red: 0.996, green: 0.552, blue: 0.059))
                                .cornerRadius(15)
                                .shadow(radius: 0.25, x: 0, y: 3)
                        }
                    }
                    .padding()
                    .frame(width: 297, height: 356)
                    .background(Color.white)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(red: 1, green: 0.91, blue: 0.78), lineWidth: 2)
                    )
                    .position(x: 195, y: 450)
                }
                
                Image("info")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 347, height: 191)
                    .padding(.bottom, -25)
                    .position(x: 200, y: 190)
            }
        }
    }
}

#Preview {
    WelcomeView()
}
