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

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(word.pinyin)
                .font(.title2)
                .fontWeight(.bold)

            Text(word.translation)
                .font(.body)

            Button {
                playAudio()
            } label: {
                HStack {
                    Image(systemName: "speaker.wave.2.fill")
                                .resizable()
                                .frame(width: 48, height: 40)
                                .foregroundColor(.black)
                    
                }
            }
            .disabled(word.audioURL == nil)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.yellow.opacity(0.1)))

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
