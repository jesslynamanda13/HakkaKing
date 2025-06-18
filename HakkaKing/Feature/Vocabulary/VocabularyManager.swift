//
//  VocabularyManager.swift
//  HakkaKing
//
//  Created by Amanda on 13/06/25.
//

// This file is already correct and needs no changes.

import SwiftUI

struct VocabularyCardManagerView: View {
    var chapter: Chapter
    @Environment(\.modelContext) private var context
    
    @State private var words: [Word] = []

    @Binding var searchText: String

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(filteredWords, id: \.id) { word in
                    VocabularyCard(word: word)
                }
                .padding(.vertical, 5)
            }
        }
        .onAppear { fetchWords() }
        .onChange(of: chapter) { _ in fetchWords() }
    }
    
    private func fetchWords() {
            let controller = ChapterController(context: context)
            words = controller.fetchWordsPerChapter(chapter: chapter)
        }
    
    private var filteredWords: [Word] {
        guard !searchText.isEmpty else { return words }
        return words.filter { $0.pinyin.localizedCaseInsensitiveContains(searchText) }
    }
}
