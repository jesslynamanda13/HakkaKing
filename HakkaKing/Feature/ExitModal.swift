//
//  ContentView.swift
//  Exit Modal Wang Hakka
//
//  Created by Chavia Viriela Budianto on 16/06/25.
//

import SwiftUI

struct ExitModalView: View {
    @Binding var isPresented: Bool
    var onExit: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 8) {
                Image("mascot-sedih")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 180, height: 180)

                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .frame(width: 100, height: 100)
                        
                            VStack(spacing: 4) {
                                Image(systemName: "face.smiling")
                                    .font(.system(size: 30))
                                    .foregroundColor(.gray)
                                Text("Character")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        }
                    )
                
                // Text
                VStack(spacing: 8) {
                    Text("Yakin mau keluar?")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    Text("Tinggal sedikit lagi loh...")
                        .font(.custom("SF Pro", size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                }
                .padding(.top, 16)
                
                // Buttons
                VStack(spacing: 24) {
                    Button(action: {
                        // Continue learning action
                        isPresented = false
                    }) {
                        Text("Lanjutkan belajar")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(red: 0.996, green: 0.522, blue: 0.059)) // #FE850F
                          
                            .cornerRadius(15)
                            .shadow(radius: 0.25, x: 0, y: 3)
                        // .shadow(color: Color(red: 0.745, green: 0.392, blue: 0.051).opacity(1), radius: 0, X: 0, Y: 5)
                    }
                    
                    Button(action: {
                        // Exit action
                        isPresented = false
                        onExit()
                    }) {
                        Text("Keluar")
                            . font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }
                }
                .padding(.vertical, 8)
            }
            .padding(24)
            
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal, 40)
        }
    }
}
