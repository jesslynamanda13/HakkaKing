//
//  EvaluationComponent.swift
//  HakkaKing
//
//  Created by Amanda on 16/06/25.
//

import SwiftUI
import AVFoundation

struct EvaluationComponent: View {
    var sentence : Sentence
    var audioURL: URL
    
    var onLanjutkan: () -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("dimsum-kerjabagus")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 320)
                .offset(y: -40).zIndex(1)
            VStack(spacing:12){
                Text(sentence.pinyin).font(.title2).fontWeight(.bold)
                Text("\"\(sentence.translation)\"")
                AudioPlayerView(audioURL: audioURL)
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                Button {
                                    onLanjutkan()
                                } label: {
                                    Text("Lanjutkan")
                                        .fontWeight(.bold)
                                        .font(.system(size: 16).weight(.bold))
                                        .foregroundColor(.putih)
                                        .padding(.vertical, 16)
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .background(.oren)
                                        .cornerRadius(15)
                                }
            }
            .padding(.top, 72)
            .padding(.horizontal, 32)
            .frame(maxWidth: .infinity)
            .background(Color.putih)
            .cornerRadius(20)
            .zIndex(0)
        }
        
       
    }
}

