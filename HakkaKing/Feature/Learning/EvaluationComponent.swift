// File: EvaluationComponent.swift
import SwiftUI
import AVFoundation

struct EvaluationComponent: View {
    var sentence: Sentence
    var wordsInSentence: [Word]
    var score: Double
    var attemptCount: Int
    var audioURL: URL?
    var analysisResult: [String: Bool]

    var onLanjutkan: () -> Void
    var onCobaLagi: () -> Void

    // --- LOGIKA BARU UNTUK MEMILIH GAMBAR ---
    private var imageNameForScore: String {
        switch score {
        case 0...20:
            return "dimsum-20" // Pastikan Anda memiliki asset gambar ini
        case 21...40:
            return "dimsum-40" // Pastikan Anda memiliki asset gambar ini
        case 41...60:
            return "dimsum-60" // Pastikan Anda memiliki asset gambar ini
        case 61...90:
            return "dimsum-coba-lagi"
        default: // Mencakup skor di atas 90, termasuk 100
            return "dimsum-kerjabagus"
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            if isPerfectScore {
                perfectScoreView
            } else {
                imperfectScoreView
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }

    private var isPerfectScore: Bool {
        score >= 100
    }

    private var perfectScoreView: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 12) {
                HighlightedPinyinView(words: wordsInSentence, analysisResult: analysisResult)
                
                Text("\"\(sentence.translation)\"")
                    .foregroundColor(.secondary)
                    .padding(.top, 8)

                if let url = audioURL {
                    AudioPlayerView(audioURL: url)
                        .padding(.top, 16).padding(.bottom, 32)
                }

                Button(action: onLanjutkan) {
                    Text("Lanjutkan")
                        .fontWeight(.bold).font(.system(size: 16))
                        .foregroundColor(Color.white)
                        .padding(.vertical, 16).frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .cornerRadius(15)
                }
            }
            .padding(.top, 80)
            .padding(.bottom, 40)
            .padding(.horizontal, 40)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: .black.opacity(0.2), radius: 20, y: -5)
            
            // --- MENGGUNAKAN GAMBAR DINAMIS ---
            Image(imageNameForScore)
                .resizable().scaledToFit().frame(height: 120)
                .offset(y: -60)
                .aspectRatio(0.75, contentMode: .fit) // <-- TAMBAHKAN BARIS INI
        }
    }
    
    private var imperfectScoreView: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 12) {
                Text("Skor Kamu: \(String(format: "%.0f", score))")
                    .font(.headline).foregroundColor(.orange)
                
                HighlightedPinyinView(words: wordsInSentence, analysisResult: analysisResult)
                
                Text("\"\(sentence.translation)\"")
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
                
                if let url = audioURL {
                    AudioPlayerView(audioURL: url)
                        .padding(.top, 16).padding(.bottom, 32)
                }

                if attemptCount >= 3 {
                    VStack(spacing: 12) {
                        Button(action: onCobaLagi) {
                            Text("Coba lagi yuk")
                                .fontWeight(.bold).font(.system(size: 16))
                                .foregroundColor(Color.white)
                                .padding(.vertical, 16).frame(maxWidth: .infinity)
                                .background(Color.orange)
                                .cornerRadius(15)
                        }
                        Button(action: onLanjutkan) {
                            Text("Selanjutnya")
                                .fontWeight(.bold).font(.system(size: 16))
                                .foregroundColor(Color.orange)
                                .padding(.vertical, 16).frame(maxWidth: .infinity)
                                .background(Color.clear)
                                .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.orange, lineWidth: 2))
                        }
                    }
                } else {
                    Button(action: onCobaLagi) {
                        Text("Coba lagi yuk")
                            .fontWeight(.bold).font(.system(size: 16))
                            .foregroundColor(Color.white)
                            .padding(.vertical, 16).frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .cornerRadius(15)
                    }
                }
            }
            .padding(.top, 80)
            .padding(.bottom, 40)
            .padding(.horizontal, 40)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: .black.opacity(0.2), radius: 20, y: -5)
            
            // --- MENGGUNAKAN GAMBAR DINAMIS ---
            Image(imageNameForScore)
                .resizable().scaledToFit().frame(height: 120)
                .offset(y: -60)
                .aspectRatio(0.75, contentMode: .fit) // <-- TAMBAHKAN BARIS INI
        }
    }
}
