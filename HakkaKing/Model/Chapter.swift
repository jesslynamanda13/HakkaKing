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
    var sentences: [UUID]
//    @Relationship var sentences: [Sentence]
    var coverImage: String

    
    init(orderIndex: Int, chapterName: String, chapterDescription: String, coverImage: String) {
        self.id = UUID()
        self.orderIndex = orderIndex
        self.chapterName = chapterName
        self.chapterDescription = chapterDescription
        self.sentences = []
        self.coverImage = coverImage
    }
    
//    func addSentence(_ sentenceUUID: UUID){
//        self.sentences.append(sentenceUUID)
//    }
}

