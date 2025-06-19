//
//  VocabularyView.swift
//  HakkaKing
//
//  Created by Amanda on 13/06/25.
//

import SwiftUI
import SwiftData

struct VocabularyView: View {
    @Query(sort: \Chapter.orderIndex) var chapters: [Chapter]
    @State private var searchText = ""
    @State private var selectedChapterIndex = 0
    
    @Environment(\.dismiss) private var dismiss
    
    var selectedChapter: Chapter? {
        guard chapters.indices.contains(selectedChapterIndex) else { return nil }
        return chapters[selectedChapterIndex]
    }

    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ZStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.dark)
                            .padding(10)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Text("Kamus Saya")
                        .font(.system(size: 24).weight(.bold))
                        .foregroundColor(.dark)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }
            
            Text("Kosakata Hakka-Indonesia yang sudah dipelajari")
                .font(.system(size: 15))
                .foregroundColor(.dark)
                .multilineTextAlignment(.leading)
            SearchAndPickerView(
                        searchText: $searchText,
                        selectedChapterIndex: $selectedChapterIndex,
                        chapters: chapters
                    )
          
            if let chapter = selectedChapter {
                

                ScrollView {
                    VocabularyCardManagerView(chapter: chapter, searchText: $searchText)
                        .id(chapter.id)

                }
            }

        }
        .padding(.top, 16)
        .padding(.horizontal, 30)
        .onAppear {
            if chapters.isEmpty == false && selectedChapterIndex >= chapters.count {
                selectedChapterIndex = 0
            }
        }
        .background(BackgroundView())
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
    }
}
