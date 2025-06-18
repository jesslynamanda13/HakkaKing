//
//  CongratsView.swift
//  HakkaKing
//
//  Created by Richard WIjaya Harianto on 17/06/25.
//

// File: CongratsView.swift (Versi Final)

import SwiftUI
import SwiftData

struct CongratsView: View {
    @State private var navigateToChapterView = false

    var body: some View {
        // Tidak perlu NavigationStack di sini
        VStack(alignment: .center) {
            Image("congrats")
                .padding(.bottom, -30)
            
            VStack(alignment: .center, spacing: 20) {
                Text("Wah, kamu hebat!")
                    .font(.system(size: 24).weight(.bold))
                    .foregroundColor(Color("Dark"))
                    .multilineTextAlignment(.center)
                
                Text("Langkah berikutnya, siap menaklukkan dunia Hakka!")
                    .font(.system(size: 16))
                    .foregroundColor(Color("Dark"))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 30)
            .padding(.top, 60)
            
            // NavigationLink yang sudah diperbaiki.
            // Tujuannya adalah ChapterView() baru dan menyembunyikan tombol kembali.
            NavigationLink(destination: ChapterView().navigationBarBackButtonHidden(true), isActive: $navigateToChapterView) {
                EmptyView()
            }
            .hidden()
            
            Button(action: {
                navigateToChapterView = true
            }) {
                Text("Kembali ke beranda")
                    .fontWeight(.bold)
                    .font(.system(size: 16).weight(.bold))
                    .foregroundColor(Color("Putih"))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 49)
                    .background(Color("Oren"))
                    .cornerRadius(15)
            }
            .shadow(color: Color.black.opacity(0.25), radius: 0.25, x: 0, y: 3)
            .padding(.top, 50)
        }
        .padding(.horizontal, 30)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BackgroundView())
        .navigationTitle("")
        .navigationBarHidden(true) // Sembunyikan tombol kembali ke LearningPage
    }
}

#Preview {
    // Tambahkan NavigationStack di preview agar NavigationLink berfungsi
    NavigationStack {
        CongratsView()
    }
}
