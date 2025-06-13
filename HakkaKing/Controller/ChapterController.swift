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
            let allSentences = try context.fetch(FetchDescriptor<Sentence>())
            return allSentences
                .filter { chapter.sentences.contains($0.id) }
                .sorted { $0.orderIndex < $1.orderIndex }
        } catch {
            print("Error fetching sentences: \(error)")
            return []
        }
    }

}
