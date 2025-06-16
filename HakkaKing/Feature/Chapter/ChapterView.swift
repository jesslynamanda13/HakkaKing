
//
//  ChapterView.swift
//  HakkaApp
//
//  Created by Marshia on 12/06/25.
//

import SwiftUI
import SwiftData

struct ChapterView: View {
    @Query(sort: \Chapter.orderIndex) var chapters: [Chapter]
    @State private var navigateToVocabView = false
    
    var body: some View {
        VStack( alignment: .leading, spacing: 16) {
                
                HStack {
                    Image("wanghakka-logo").resizable().scaledToFit().frame(maxWidth: 90)
                    Spacer()
                    
                    Button(action: {
                        navigateToVocabView = true
                    }) {
                        Image(systemName: "text.book.closed.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .foregroundColor(.oren)
                            .padding(12)
                            .background(.orangeBorder)
                            .clipShape(Circle())
                            .shadow(color: Color(red: 236/255, green: 202/255, blue: 114/255), radius: 0, x: -2, y: 2)
                    }
                }
                Text("Ayo mulai belajar!")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.black)
                
                Text("Mulai perjalananmu belajar bahasa Hakka-Indonesia dengan berbagai topik seru.")
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .padding(.top, -8)
                    .padding(.bottom, 4)
                
            
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Chapter Cards
                        ForEach(Array(chapters.enumerated()), id: \.1.id) { index, chapter in ChapterCard(chapter: chapter, index: index)
                        }
                        .padding(.bottom, 4)
                    }
                    
                    
                }
            }
            .padding(.horizontal, 32)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(BackgroundView())
            .navigationTitle("")
            .navigationBarHidden(true)
    }
}

#Preview {
    ChapterView()
}

