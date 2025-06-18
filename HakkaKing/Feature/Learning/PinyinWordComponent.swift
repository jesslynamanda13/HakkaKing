//
//  PinyinWordComponent.swift
//  HakkaKing
//
//  Created by Amanda on 17/06/25.
//

import SwiftUI
import AVFoundation
import SwiftData

struct PinyinWordComponent: View {
    var sentence: Sentence
    
    @Environment(\.modelContext) private var context
    
    @Query private var sentenceWords: [SentenceWord] // Query all first
    @Query private var words: [Word]
    
    @State private var audioPlayer: AVAudioPlayer?

    private func word(for sentenceWord: SentenceWord) -> Word? {
        return words.first { $0.id == sentenceWord.wordID }
    }
    
    private func playWordAudio(urlString: String?) {
        guard let urlString = urlString,
              let url = Bundle.main.url(forResource: urlString, withExtension: nil) else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Failed to play audio: \(error)")
        }
    }
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 60), spacing: 1)]){
            ForEach(sentenceWords
                    .filter { $0.sentenceID == sentence.id }
                    .sorted { $0.position < $1.position }
            ) { sentenceWord in
                
                if let word = word(for: sentenceWord) {
                    Text(word.pinyin)
                        .font(.title3)
                        .fontWeight(.bold)
                        .underline()
                        .onTapGesture {
                            playWordAudio(urlString: word.audioURL)
                        }
                        .padding(4)
                }
            }
        }
        .padding()
    }
}
