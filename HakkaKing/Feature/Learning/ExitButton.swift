//
//  ExitButton.swift
//  HakkaKing
//
//  Created by Amanda on 16/06/25.
//

import SwiftUI
struct ExitButton: View {
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    
    var body: some View {
        Button {
            showAlert = true
        } label: {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 40, height: 40)

                Image(systemName: "xmark")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
        }
        .alert("Are you sure you want to exit?", isPresented: $showAlert) {
            Button("Yes") {
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}
