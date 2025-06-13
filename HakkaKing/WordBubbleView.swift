//
//  WordBubbleView.swift
//  HakkaKing
//
//  Created by Amanda on 13/06/25.
//
import SwiftUI
import AVFoundation

struct WordBubble: View {
    let word: Word
    @State private var showTranslation = false
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        
            Text(word.pinyin)
                .font(.title2)
                .padding(.horizontal, 4)
                .onTapGesture {
                    showTranslation.toggle()
                    playAudio()
                }
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onChange(of: showTranslation) { _ in
                                // You can add logic here if needed
                            }
                            .overlay(
                                Group {
                                    if showTranslation {
                                        VStack(spacing: 4) {
                                            Text(word.translation)
                                                .font(.caption)
                                                .padding(6)
                                                .background(Color.white)
                                                .cornerRadius(8)
                                                .shadow(radius: 2)
                                            
                                            Triangle()
                                                .fill(Color.white)
                                                .frame(width: 10, height: 5)
                                        }
                                        .position(x: geo.size.width / 2, y: geo.size.height + 30)
                                        .transition(.opacity)
                                        .zIndex(1)
                                    }
                                }
                            )
                    }
                )
        
    }

    private func playAudio() {
        guard let fileName = word.audioURL,
              let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            print("Audio file not found for word: \(word.pinyin)")
            return
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            audioPlayer = player
            player.prepareToPlay()
            player.play()
        } catch {
            print("Failed to play audio for word \(word.pinyin): \(error.localizedDescription)")
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY)) // top
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)) // bottom right
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY)) // bottom left
        path.closeSubpath()
        return path
    }
}
