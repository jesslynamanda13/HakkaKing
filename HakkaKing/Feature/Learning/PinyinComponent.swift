//
//  PinyinComponent.swift
//  HakkaKing
//
//  Created by Amanda on 16/06/25.
//

import SwiftUI
import AVFoundation

struct PinyinComponent: View {
    @State private var audioPlayer: AVAudioPlayer?
    var sentence : Sentence
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Image(sentence.character)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 120)
            }
            HStack(spacing: 12){
                Button {
                    playAudio(fileName: sentence.audioURL)
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 45, height: 45)
                        
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                VStack(alignment: .center, spacing: 8){
                    PinyinWordComponent(sentence: sentence)
                    Text("\"\(sentence.translation)\"")
                        .font(.subheadline)
                        .foregroundStyle(Color.gray.opacity(0.8))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(Color.white)
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("OrangeBorder"), lineWidth: 2))
            }
            
            .offset(y: 108)
        }
    }
    
    private func playAudio(fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            print("Sentence audio not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            print("Played")
        } catch {
            print(
                "Failed to play sentence audio: \(error.localizedDescription)"
            )
        }
    }
}
