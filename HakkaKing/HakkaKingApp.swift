//
//  HakkaKingApp.swift
//  HakkaKing
//
//  Created by Amanda on 12/06/25.
//

import SwiftUI
import SwiftData

@main
struct HakkaKingApp: App {
    var body: some Scene {
        let container = try! ModelContainer(for: Chapter.self, Sentence.self, Word.self, SentenceWord.self)
        
        let context = ModelContext(container)
        
        if (try? context.fetch(FetchDescriptor<Chapter>()))?.isEmpty ?? true {
            seedDatabase(context: context)
        }
        
        return WindowGroup {
            SplashScreenView()
                .modelContainer(container)
                .preferredColorScheme(.light)
        }
    }
}
