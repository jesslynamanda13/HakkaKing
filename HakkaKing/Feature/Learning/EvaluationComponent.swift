// File: EvaluationComponent.swift
import SwiftUI
import AVFoundation

struct EvaluationComponent: View {
    var sentence: Sentence
    var wordsInSentence: [Word] // Menerima daftar kata
    var score: Double
    var attemptCount: Int
    var audioURL: URL?
    var analysisResult: [String: Bool]

    var onLanjutkan: () -> Void
    var onCobaLagi: () -> Void

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
                // Menggunakan view yang baru dengan data yang benar
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
            
            Image("dimsum-kerjabagus")
                .resizable().scaledToFit().frame(height: 120)
                .offset(y: -60)
        }
    }
    
    private var imperfectScoreView: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 12) {
                Text("Skor Kamu: \(String(format: "%.0f", score))")
                    .font(.headline).foregroundColor(.orange)
                
                // Menggunakan view yang baru dengan data yang benar
                HighlightedPinyinView(words: wordsInSentence, analysisResult: analysisResult)
                
                Text("\"\(sentence.translation)\"")
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
                
                if let url = audioURL {
                    AudioPlayerView(audioURL: url)
                        .padding(.top, 16).padding(.bottom, 32)
                }

                // --- FIX: Mengisi kembali konten tombol yang hilang ---
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
            
            Image("dimsum-coba-lagi")
                .resizable().scaledToFit().frame(height: 120)
                .offset(y: -60)
        }
    }
}
