//
//  ChapterController.swift
//  HakkaKing
//
//  Created by Amanda on 12/06/25.
//

import Foundation
import SwiftData

class ChapterController {
    let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchChapters() -> [Chapter] {
        let descriptor = FetchDescriptor<Chapter>(
            sortBy: [SortDescriptor(\.chapterName, order: .forward)]
        )

        do {
            return try context.fetch(descriptor)
        } catch {
            print("Failed to fetch chapters: \(error)")
            return []
        }
    }

    func fetchSentences(for chapter: Chapter, context: ModelContext) -> [Sentence] {
        do {
            let allSentences = try context.fetch(FetchDescriptor<Sentence>(sortBy: [SortDescriptor(\.orderIndex, order: .forward)]))
            let sentences = allSentences
                .filter { chapter.sentences.contains($0.id) }
                .sorted { $0.orderIndex < $1.orderIndex }
            return sentences
        } catch {
            print("Error fetching sentences: \(error)")
            return []
        }
    }

    
    func fetchWords(chapter: Chapter) -> [Word] {
        do {
            let allSentences = try context.fetch(FetchDescriptor<Sentence>())
            let chapterSentences = allSentences
                .filter { chapter.sentences.contains($0.id) }
            
            let sentenceIDs = chapterSentences.map { $0.id }
            
            let allSentenceWords = try context.fetch(FetchDescriptor<SentenceWord>())
            let relatedSentenceWords = allSentenceWords
                .filter { sentenceIDs.contains($0.sentenceID) }
            
            let wordIDs = Set(relatedSentenceWords.map { $0.wordID })
            
            let allWords = try context.fetch(FetchDescriptor<Word>())
            let words = allWords.filter { wordIDs.contains($0.id) }
            
            return words
        } catch {
            print("Error fetching words for chapter \(chapter.chapterName): \(error)")
            return []
        }
    }


}
