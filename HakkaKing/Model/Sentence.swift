//
//  Sentence.swift
//  HakkaLearningApp
//
//  Created by Amanda on 12/06/25.
//

import Foundation
import SwiftData

@Model
final class Sentence {
    @Attribute(.unique) var id: UUID
    var orderIndex: Int
    var pinyin: String
    var hanzi: String
    var translation: String
    var audioURL: String?
    
    // The inverse relationship back to the parent Chapter
    var chapter: Chapter?
    
    init(orderIndex: Int, pinyin: String, hanzi: String, translation: String, audioURL: String?) {
        self.id = UUID()
        self.orderIndex = orderIndex
        self.pinyin = pinyin
        self.hanzi = hanzi
        self.translation = translation
        self.audioURL = audioURL
    }
}
