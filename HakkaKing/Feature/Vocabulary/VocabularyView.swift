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
    @State private var navigateToChapterView: Bool = false
    
    
    var body: some View{
        VStack(alignment: .leading, spacing: 20) {
            ZStack{
                HStack {
                    
                    // Navigate ke ChapterView()
                    NavigationLink(destination: ChapterView(), isActive: $navigateToChapterView) {
                        EmptyView()
                    }
                    .hidden()
                    
                    //button align right
                    Spacer()
                    Button(action: {
                        navigateToChapterView = true
                    }) {
//                                Image(systemName: "chevron.left")
                        Image(systemName: "xmark")
                            .foregroundColor(.dark)
                            .padding(12)
                            .background(.putih)
                            .clipShape(Circle())
                    }
                    //button align left
//                            Spacer()
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
            
            Text("Koleksi kata-kata Hakka-Indonesia yang telah kamu pelajari, siap untuk memperkaya wawasan bahasa Hakka kamu.")
                .font(.system(size: 14))
                .foregroundColor(.dark)
                .multilineTextAlignment(.leading)
            
//            ChapterDropdown(selectedChapter: $selectedChapter, chapters: chapters)
            
            if let chapter = selectedChapter {
                ScrollView {
                       VocabularyCardManagerView(chapter: chapter)
                           .id(chapter.id)
                   }
            }
        }
        .padding(.horizontal, 30)
        .onAppear {
            if selectedChapter == nil{
                selectedChapter = chapters.first
            }
        }
        .background(BackgroundView())
    }
}

