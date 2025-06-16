//
//  VocabularyManager.swift
//  HakkaKing
//
//  Created by Amanda on 13/06/25.
//

import SwiftUI

struct VocabularyCardManagerView: View {
    var chapter: Chapter
    @Environment(\.modelContext) private var context
    
    @State private var words: [Word] = []

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(words, id: \.id) { word in
                    VocabularyCard(word: word)
                }
            }
        }
        .onAppear {
            let controller = ChapterController(context: context)
            words = controller.fetchWords(chapter: chapter)
        }
    }
}
