//
//  ContentView.swift
//  HakkaKing
//
//  Created by Amanda on 12/06/25.
////
///
//
import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            ChapterView()
                .tabItem {
                    Image(systemName: "book")
                    Text("Chapters")
                }
            
            
            VocabularyView()
                .tabItem {
                    Image(systemName: "square.text.square")
                    Text("Vocabulary")
                }
        }
    }
    //    // Display All Chapter
    //    @Query(sort: \Chapter.orderIndex) var chapters: [Chapter]
    //
    //    var body: some View {
    //        // Dicomment aja nanti
    //        NavigationStack {
    //            List(chapters) { chapter in
    //                NavigationLink(destination: SentenceListView(chapter: chapter)) {
    //                    VStack(alignment: .leading) {
    //                        Text(chapter.chapterName)
    //                            .font(.headline)
    //                        Text(chapter.chapterDescription)
    //                            .font(.subheadline)
    //                            .foregroundColor(.secondary)
    //                    }
    //                }
    //            }
    //            .navigationTitle("Chapters")
    //        }
    //    }
}
