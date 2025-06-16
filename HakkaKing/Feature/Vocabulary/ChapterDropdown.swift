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

//    let lightGrayColor = Color(red: 200/255, green: 200/255, blue: 200/255)

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
//                    .font(.headline)
//                    .foregroundStyle(Color.black)
                    .font(.system(size: 16))
                    .foregroundColor(.putih)
                    .padding(.vertical, 10)
                Spacer()
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
//                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
//                        .foregroundStyle(.putih)
//                        .padding(.trailing, 10)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 10)
            .background(.oren)
            .cornerRadius(10)
            .shadow(radius: 0.25, x: 0, y: 3)

//            .overlay(
//                RoundedRectangle(cornerRadius: 8)
//                    .stroke(lightGrayColor, lineWidth: 1)
//            )

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
                            .font(.system(size: 16))
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation {
                                    isExpanded = false
                                }
                                selectedChapter = chapter
                                dropdownLabel = chapter.chapterName
                            }
                            .background(.oren)

                        Divider()
                    }

                }
                .frame(maxHeight: 100)
                .background(.oren)
                .cornerRadius(10)
//                .shadow(radius: 5)
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

