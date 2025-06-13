//
//  SentenceWord.swift
//  HakkaLearningApp
//
//  Created by Amanda on 12/06/25.
//

import Foundation
import SwiftData

@Model
class SentenceWord{
    var id: UUID
    var sentenceID: UUID
    var wordID: UUID
    var position:Int
    
    init(sentenceID: UUID, wordID: UUID, position: Int) {
        self.id = UUID()
        self.sentenceID = sentenceID
        self.wordID = wordID
        self.position = position
    }
}
