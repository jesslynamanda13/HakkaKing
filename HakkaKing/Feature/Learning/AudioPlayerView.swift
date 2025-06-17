//
//  AudioPlayerView.swift
//  HakkaKing
//
//  Created by Amanda on 16/06/25.
//
//

import SwiftUI
import AVFoundation

struct AudioPlayerView: View {
    let audioURL: URL
    
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying = false
    
    var body: some View {
        HStack(spacing: 8) {
            Button {
                isPlaying.toggle()
                if isPlaying {
                    playAudio()
                } else {
                    pauseAudio()
                }
            } label: {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(.black)
            }
            .padding()

            HStack(spacing: 2) {
                ForEach(0..<40, id: \.self) { i in
                    let height = Bool.random() ? 10 : 30
                    Capsule()
                        .fill(Color.black)
                        .frame(width: 3, height: CGFloat(height))
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .frame(maxWidth: 320)
        .background(RoundedRectangle(cornerRadius: 12).stroke(Color("OrangeBorder"), lineWidth: 2))
    }
    
    private func playAudio() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Playback failed: \(error.localizedDescription)")
        }
    }
    
    private func pauseAudio() {
        audioPlayer?.pause()
    }
}
