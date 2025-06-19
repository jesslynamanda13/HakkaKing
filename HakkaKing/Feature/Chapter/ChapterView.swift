
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
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top){
                    VStack(alignment: .leading, spacing: 5){
                        Text("Topik Pembelajaran")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("Kamu bisa belajar dengan topik seru seputar kegiatan keseharian")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .padding(.bottom,10)
                    }
                    .padding(.trailing, 8)
                    Spacer()
                    VStack{
                        Button(action: {
                            navigateToVocabView = true
                        }) {
                            Image("vocab-icon")
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
                    
                }
                
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Chapter Cards
                        ForEach(Array(chapters.enumerated()), id: \.1.id) { index, chapter in
                            ChapterCard(chapter: chapter, index: index)
                        }
                        .padding(.bottom, 4)
                    }
                }.padding(.top, 8)
            }
            .padding(.top, 32)
            .padding(.horizontal, 32)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(BackgroundView())
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToVocabView) {
                // Replace with your VocabView
                VocabularyView()
            }
        }
    }
}

