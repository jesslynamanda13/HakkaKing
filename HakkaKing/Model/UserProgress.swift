//
//  UserProgress.swift
//  HakkaLearningApp
//
//  Created by Amanda on 12/06/25.
//

import Foundation
import SwiftData

@Attribute
enum ChapterStatus: String, Codable {
    case noAttempt = "No attempt"
    case attempt = "Attempt"
    case finished = "Finished"
}

@Model
class UserProgress {
    var id: UUID
    var userID: UUID
    var chapterID: UUID
    var chapterStatus: ChapterStatus

    init(id: UUID = UUID(), userID: UUID, chapterID: UUID, chapterStatus: ChapterStatus) {
        self.id = id
        self.userID = userID
        self.chapterID = chapterID
        self.chapterStatus = chapterStatus
    }
}
