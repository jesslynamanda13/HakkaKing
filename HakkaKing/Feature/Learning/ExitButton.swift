//
//  ExitButton.swift
//  HakkaKing
//
//  Created by Amanda on 16/06/25.
//

import SwiftUI
struct ExitButton: View {
    @Binding var showExitModal: Bool
    
    var body: some View {
        Button {
            showExitModal = true
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
    }
}

