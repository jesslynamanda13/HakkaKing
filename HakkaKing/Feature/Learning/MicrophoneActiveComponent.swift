//
//  MicrophoneActiveComponent.swift
//  HakkaKing
//
//  Created by Amanda on 16/06/25.
//

import SwiftUI

struct MicrophoneActiveComponent: View {
    @Binding var isRecording: Bool
    var body: some View {
        Button {
            isRecording = false
        } label: {
            Image("mic-record")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 84)
        }
    }
}
