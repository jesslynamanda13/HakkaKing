//
//  CompletedSentences.swift
//  HakkaLearningApp
//
//  Created by Amanda on 12/06/25.
//

import Foundation
import SwiftData

@Model
class CompletedSentences{
    // completed sentences per chapter
    var id:UUID
    var userID:UUID
    var chapterID:UUID
    var sentencesID: [UUID]
    
    init(userID: UUID, chapterID: UUID, sentencesID: [UUID]) {
        self.id = UUID()
        self.userID = userID
        self.chapterID = chapterID
        self.sentencesID = sentencesID
    }
}
