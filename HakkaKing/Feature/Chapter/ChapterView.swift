////
////  ChapterView.swift
////  HakkaKing
////
////  Created by Amanda on 13/06/25.
////
//
//import SwiftUI
//import SwiftData
//
//struct ChapterView: View {
//    @Query(sort: \Chapter.orderIndex) var chapters: [Chapter]
//    
//    var body: some View {
//        NavigationView {
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
//}
//
