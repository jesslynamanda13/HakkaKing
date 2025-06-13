//
//  Chapter.swift
//  HakkaLearningApp
//
//  Created by Amanda on 12/06/25.
//

import Foundation
import SwiftData

@Model
class Chapter{
    var id: UUID
    var orderIndex: Int
    var chapterName: String
    var chapterDescription: String
    var sentences: [UUID]
    
    
    init(orderIndex: Int, chapterName: String, chapterDescription: String) {
        self.id = UUID()
        self.orderIndex = orderIndex
        self.chapterName = chapterName
        self.chapterDescription = chapterDescription
        self.sentences = []
    }
    
    func addSentence(_ sentenceUUID: UUID){
        self.sentences.append(sentenceUUID)
    }
}

