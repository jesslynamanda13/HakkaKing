//
//  PinyinWordComponent.swift
//  HakkaKing
//
//  Created by Amanda on 17/06/25.
//
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
        VStack(alignment: .leading) {
            GeometryReader { geometry in
                generateWrappedContent(in: geometry)
            }
            .frame(maxHeight: 120)
        }

    }
    private func generateWrappedContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        let sortedWords = sentenceWords
            .filter { $0.sentenceID == sentence.id }
            .sorted { $0.position < $1.position }

        return ZStack(alignment: .topLeading) {
            ForEach(sortedWords) { sentenceWord in
                if let word = word(for: sentenceWord) {
                    Text(word.pinyin)
                        .font(.title2)
                        .fontWeight(.bold)
                        .underline()
                        .padding(4)
                        .alignmentGuide(.leading, computeValue: { d in
                            if abs(width - d.width) > geometry.size.width {
                                width = 0
                                height -= d.height
                            }
                            let result = width
                            width -= d.width
                            return result
                        })
                        .alignmentGuide(.top, computeValue: { _ in
                            let result = height
                            return result
                        })
                        .onTapGesture {
                            playWordAudio(urlString: word.audioURL)
                        }
                }
            }
        }
    }

}
