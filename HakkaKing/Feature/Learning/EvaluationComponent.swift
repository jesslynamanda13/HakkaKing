//
//  EvaluationComponent.swift
//  HakkaKing
//
//  Created by Amanda on 16/06/25.
//
//
//import SwiftUI
//import AVFoundation
//
//struct EvaluationComponent: View {
//    var sentence : Sentence
//    var audioURL: URL
//    
//    var onLanjutkan: () -> Void
//    
//    var body: some View {
//        ZStack(alignment: .top) {
//            Image("dimsum-kerjabagus")
//                .resizable()
//                .scaledToFit()
//                .frame(maxWidth: 320)
//                .offset(y: -40).zIndex(1)
//            VStack(spacing:12){
//                Text(sentence.pinyin).font(.title2).fontWeight(.bold)
//                Text("\"\(sentence.translation)\"")
//                AudioPlayerView(audioURL: audioURL)
//                    .padding(.top, 16)
//                    .padding(.bottom, 32)
//                Button {
//                                    onLanjutkan()
//                                } label: {
//                                    Text("Lanjutkan")
//                                        .fontWeight(.bold)
//                                        .font(.system(size: 16).weight(.bold))
//                                        .foregroundColor(.putih)
//                                        .padding(.vertical, 16)
//                                        .frame(minWidth: 0, maxWidth: .infinity)
//                                        .background(.oren)
//                                        .cornerRadius(15)
//                                }
//            }
//            .padding(.top, 72)
//            .padding(.horizontal, 32)
//            .frame(maxWidth: .infinity)
//            .background(Color.putih)
//            .cornerRadius(20)
//            .zIndex(0)
//        }
//        
//       
//    }
//}
//

import SwiftUI
import AVFoundation

struct EvaluationComponent: View {
    var sentence: Sentence
    var score: Double
    var audioURL: URL?
    var onLanjutkan: () -> Void
    var onUlangi: () -> Void

    var body: some View {
        let isPerfectScore = score >= 100

        if isPerfectScore {
            // Tampilan ASLI Anda jika skor 100
            ZStack(alignment: .top) {
                Image("dimsum-kerjabagus")
                    .resizable().scaledToFit().frame(maxWidth: 320)
                    .offset(y: -40).zIndex(1)
                
                VStack(spacing:12){
                    Text(sentence.pinyin).font(.title2).fontWeight(.bold)
                    Text("\"\(sentence.translation)\"")
                    
                    if let url = audioURL {
                        AudioPlayerView(audioURL: url)
                            .padding(.top, 16).padding(.bottom, 32)
                    }

                    Button(action: onLanjutkan) {
                        Text("Lanjutkan").fontWeight(.bold)
                            .font(.system(size: 16).weight(.bold))
                            .foregroundColor(Color("Putih"))
                            .padding(.vertical, 16).frame(maxWidth: .infinity)
                            .background(Color("Oren")).cornerRadius(15)
                    }
                }
                .padding(.top, 72).padding(.horizontal, 32)
                .frame(maxWidth: .infinity).background(Color("Putih"))
                .cornerRadius(20).zIndex(0)
            }
            .padding(.horizontal, 32)
            
        } else {
            // Tampilan BARU jika skor < 100, dengan UI yang sama
            ZStack(alignment: .top) {
                Image("dimsum-coba-lagi") // Menggunakan gambar yang berbeda
                    .resizable().scaledToFit().frame(maxWidth: 320)
                    .offset(y: -40).zIndex(1)
                
                VStack(spacing:12){
                    Text("Skor Kamu: \(String(format: "%.0f", score))")
                        .font(.headline).foregroundColor(.orange)
                    
                    Text(sentence.pinyin).font(.title2).fontWeight(.bold)
                    Text("\"\(sentence.translation)\"")
                    
                    if let url = audioURL {
                        AudioPlayerView(audioURL: url)
                            .padding(.top, 16).padding(.bottom, 32)
                    }

                    // Dua Tombol
                    HStack {
                        Button(action: onUlangi) {
                            Text("Ulangi")
                                .fontWeight(.bold).font(.system(size: 16))
                                .foregroundColor(Color("Oren")).padding(.vertical, 16)
                                .frame(maxWidth: .infinity).background(Color.clear)
                                .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color("Oren"), lineWidth: 2))
                        }
                        Button(action: onLanjutkan) {
                            Text("Lanjutkan")
                                .fontWeight(.bold).font(.system(size: 16))
                                .foregroundColor(Color("Putih")).padding(.vertical, 16)
                                .frame(maxWidth: .infinity).background(Color("Oren"))
                                .cornerRadius(15)
                        }
                    }
                }
                .padding(.top, 72).padding(.horizontal, 32)
                .frame(maxWidth: .infinity).background(Color("Putih"))
                .cornerRadius(20).zIndex(0)
            }
            .padding(.horizontal, 32)
        }
    }
}
