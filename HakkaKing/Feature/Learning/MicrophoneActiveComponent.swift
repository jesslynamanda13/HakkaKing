//
//  MicrophoneActiveComponent.swift
//  HakkaKing
//
//  Created by Amanda on 16/06/25.
//

import SwiftUI

struct MicrophoneActiveComponent: View {
    @Binding var isRecording: Bool
    var isAnalyzing: Bool // Tambahkan ini

    var body: some View {
        VStack(spacing: 8) {
            if isAnalyzing {
                ProgressView()
                Text("Analyzing...").font(.caption)
            } else {
                RecordButtonView()
//                Button(action: { /* Stop logic is in RecordingController */ }) {
//                    Image("mic-record").resizable().scaledToFit().frame(maxWidth: 84)
//                }
            }
        }
    }
}

