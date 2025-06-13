//
//  Word.swift
//  HakkaLearningApp
//
//  Created by Amanda on 12/06/25.
//

import Foundation
import SwiftData

@Model
class Word{
    var id:UUID
    var pinyin:String
    var translation:String
    var audioURL:String?
    
    init(pinyin: String, translation: String, audioURL: String?) {
        self.id = UUID()
        self.pinyin = pinyin
        self.translation = translation
        self.audioURL = audioURL
    }
}
