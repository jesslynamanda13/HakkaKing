//
//  SentenceListView.swift
//  HakkaKing
//
//  Created by Amanda on 13/06/25.
//
import SwiftUI
import SwiftData
import AVFoundation

struct SelectedWordOverlay {
    let word: Word
    let position: CGPoint
    let size: CGSize
}

struct SentenceListView: View {
    var chapter: Chapter
    @Query(sort: \Sentence.orderIndex) var allSentences: [Sentence]
    @Query var sentenceWords: [SentenceWord]
    @Query var allWords: [Word]
    @State private var visibleWordID: UUID? = nil
    
    
    var body: some View {
        let sentences = allSentences.filter { chapter.sentences.contains($0.id) }
        
        return List(sentences) { sentence in
            VStack(alignment: .leading, spacing: 6) {
                // Display sentence Hanzi
                Text(sentence.hanzi)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                
                let relatedSentenceWords = sentenceWords
                    .filter { $0.sentenceID == sentence.id }
                    .sorted { $0.position < $1.position }
                
                let words = relatedSentenceWords.compactMap { sw in
                    allWords.first { $0.id == sw.wordID }
                }
                
                ZStack(alignment: .topLeading) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            ForEach(words, id: \.id) { word in
                                WordBubble(word: word)
                            }
                        }
                        
                        HStack {
                            Text(sentence.translation)
                                .font(.body)
                            Spacer()
                            Button(action: {
                                playSentenceAudio(for: sentence)
                            }) {
                                Image(systemName: "play.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    ForEach(words, id: \.id) { word in
                        if visibleWordID == word.id {
                            TranslationBubble(text: word.translation)
                                .position(x: 50, y: 50)
                                .zIndex(1000)
                        }
                    }
                }
                
                
                //                HStack(spacing: 8) {
                //                    ForEach(words, id: \.id) { word in
                //                        WordBubble(word: word)
                //                    }
                //                }
                //
                //                HStack {
                //                    Text(sentence.translation)
                //                        .font(.body)
                //                    Spacer()
                //                    Button(action: {
                //                        playSentenceAudio(for: sentence)
                //                    }) {
                //                        Image(systemName: "play.circle.fill")
                //                            .resizable()
                //                            .frame(width: 30, height: 30)
                //                            .foregroundColor(.blue)
                //                    }
                //                    .buttonStyle(.plain)
                //                }
            }
            .padding(.vertical, 6)
        }
        .navigationTitle(chapter.chapterName)
    }
    
    @State private var audioPlayer: AVAudioPlayer?
    
    private func playSentenceAudio(for sentence: Sentence) {
        let fileName = sentence.audioURL
        guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            print("Sentence audio not found")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            audioPlayer = player
            player.prepareToPlay()
            player.play()
        } catch {
            print("Failed to play sentence audio: \(error.localizedDescription)")
        }
    }
}

struct TranslationBubble: View {
    var text: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(text)
                .font(.caption)
                .padding(6)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 2)
            
            Triangle()
                .fill(Color.white)
                .frame(width: 10, height: 5)
        }
    }
}
