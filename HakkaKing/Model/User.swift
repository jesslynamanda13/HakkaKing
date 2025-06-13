//
//  User.swift
//  HakkaLearningApp
//
//  Created by Amanda on 09/06/25.
//

import Foundation
import SwiftData

@Model
class User {
    var id: UUID
    
    init() {
        self.id = UUID()
    }
}

