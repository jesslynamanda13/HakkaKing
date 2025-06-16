//
//  VocabularyCard.swift
//  HakkaKing
//
//  Created by Amanda on 13/06/25.
//

import SwiftUI
import AVFoundation

struct VocabularyCard: View {
    var word: Word
    
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying = false

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(word.pinyin)
                .font(.system(size: 17).weight(.bold))
                .foregroundColor(.dark)

            Text(word.translation)
                .font(.system(size: 12))
                .foregroundColor(.dark)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)

            Button {
                isPlaying = true
                playAudio()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    withAnimation {
                        isPlaying = false
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "speaker.wave.2.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 34, height: 34)
                        .foregroundColor(isPlaying ? .oren : .dark)
                    
                }
            }
            .disabled(word.audioURL == nil)
        }
        .padding()
        .frame(width: 150, height: 150)
        .background(.putih)
        .cornerRadius(20)
        .shadow(radius: 0.25, x: -2, y: 2)

    }
    
    private func playAudio() {
        guard let fileName = word.audioURL,
              let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            print("Audio file not found for \(word.pinyin)")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            audioPlayer = player
            player.prepareToPlay()
            player.play()
        } catch {
            print("Failed to play audio for \(word.pinyin): \(error.localizedDescription)")
        }
    }
}

#Preview{
    return VocabularyCard(word: Word(
                pinyin: "nǐ hǎo",
                translation: "hello",
                audioURL: "nyi.m4a"
            ))
            .padding()
}
