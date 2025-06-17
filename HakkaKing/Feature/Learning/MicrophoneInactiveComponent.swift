//
//  MicrophoneComponent.swift
//  HakkaKing
//
//  Created by Amanda on 16/06/25.
//

import SwiftUI
struct MicrophoneInactiveComponent: View {
    @Binding var isRecording: Bool
    @StateObject var recordingController: RecordingController
    
    var body: some View {
        Button {
            isRecording = true
            recordingController.requestPermissionAndRecord()
        } label: {
            Image("mic")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 84)
        }
        
    }
}

