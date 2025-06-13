//
//  SeedDatabase.swift
//  HakkaLearningApp
//
//  Created by Amanda on 12/06/25.
//

import Foundation
import SwiftData

public func seedDatabase(context: ModelContext) {
    seedChapter1(context: context)
    seedChapter2(context: context)
    seedChapter3(context: context)
    print("Seeding successful")
}


