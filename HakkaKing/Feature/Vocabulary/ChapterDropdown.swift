//
//  ChapterDropdown.swift
//  HakkaKing
//
//  Created by Amanda on 13/06/25.
//

import SwiftUI
import SwiftData

struct ChapterDropdown: View {
    @State private var isExpanded = false
    @State private var dropdownLabel: String
    @Binding var selectedChapter: Chapter?

    let lightGrayColor = Color(red: 200/255, green: 200/255, blue: 200/255)

    var chapters: [Chapter]

    init(selectedChapter: Binding<Chapter?>, chapters: [Chapter]) {
        self._selectedChapter = selectedChapter
        self.chapters = chapters
        self._dropdownLabel = State(initialValue: selectedChapter.wrappedValue?.chapterName ?? "Chapter 1")
    }
  
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(dropdownLabel)
                    .lineLimit(1)
                    .font(.headline)
                    .foregroundStyle(Color.black)
                Spacer()
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(Color.yellow)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .background(Color.clear)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lightGrayColor, lineWidth: 1)
            )

            if isExpanded {
//                ScrollView {
//                    LazyVStack(spacing: 0) {
//                        ForEach(chapters.filter { $0.id != selectedChapter?.id }, id: \.id) { chapter in
//                            Text(chapter.chapterName)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .padding()
//                                .font(.headline)
//                                .contentShape(Rectangle())
//                                .onTapGesture {
//                                    withAnimation {
//                                        isExpanded = false
//                                    }
//                                    selectedChapter = chapter
//                                    dropdownLabel = chapter.chapterName
//                                }
//                                .background(Color.white)
//
//                            Divider()
//                        }
//
//                    }
//                }
                LazyVStack(spacing: 0) {
                    ForEach(chapters.filter { $0.id != selectedChapter?.id }, id: \.id) { chapter in
                        Text(chapter.chapterName)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .font(.headline)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation {
                                    isExpanded = false
                                }
                                selectedChapter = chapter
                                dropdownLabel = chapter.chapterName
                            }
                            .background(Color.white)

                        Divider()
                    }

                }
                .frame(maxHeight: 100)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 5)
                .transition(.opacity)
                .zIndex(999)
            }
        }
        .background(
            isExpanded ?
                Color.black.opacity(0.0001)
                    .onTapGesture {
                        withAnimation {
                            isExpanded = false
                        }
                    }
                    .ignoresSafeArea()
                : nil
        )
    }
}

