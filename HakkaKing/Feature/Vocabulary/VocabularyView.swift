//
//  VocabularyView.swift
//  HakkaKing
//
//  Created by Amanda on 13/06/25.
//

import SwiftUI
import SwiftData

struct VocabularyView : View{
    @Query(sort: \Chapter.orderIndex) var chapters: [Chapter]
    @State private var selectedChapter: Chapter?
    var body: some View{
        VStack(alignment: .leading) {
            Text("Vocabulary").font(.headline)
            ChapterDropdown(selectedChapter: $selectedChapter, chapters: chapters)
            
            if let chapter = selectedChapter {
                ScrollView {
                       VocabularyCardManagerView(chapter: chapter)
                           .id(chapter.id) 
                   }
            }
        }
        .padding(.horizontal, 32)
            .onAppear {
                        if selectedChapter == nil{
                            selectedChapter = chapters.first
                        }
                    }
    }
}
