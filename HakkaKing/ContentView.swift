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
        ChapterView()
            .tabItem {
                Image(systemName: "book")
                Text("Chapters")
            }.navigationBarHidden(true)
    }
}
