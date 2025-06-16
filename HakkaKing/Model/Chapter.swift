//
//  Chapter.swift
//  HakkaLearningApp
//
//  Created by Amanda on 12/06/25.
//

import Foundation
import SwiftData

@Model
final class Chapter {
    @Attribute(.unique) var id: UUID
    var orderIndex: Int
    var chapterName: String
    var chapterDescription: String
    
    @Relationship(deleteRule: .cascade, inverse: \Sentence.chapter)
    var sentences: [Sentence]? = []
    
    init(orderIndex: Int, chapterName: String, chapterDescription: String) {
        self.id = UUID()
        self.orderIndex = orderIndex
        self.chapterName = chapterName
        self.chapterDescription = chapterDescription
    }
}

