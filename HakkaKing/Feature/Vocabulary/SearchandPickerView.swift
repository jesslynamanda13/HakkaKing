//
//  SearchandPickerView.swift
//  HakkaKing
//
//  Created by Amanda on 17/06/25.
//

import SwiftUI
struct SearchAndPickerView: View {
    @Binding var searchText: String
    @Binding var selectedChapterIndex: Int
    var chapters: [Chapter]

    var body: some View {
        HStack {
            TextField("Cari kata", text: $searchText)
                .padding(.horizontal, 38)
                .frame(height: 40)
                .background(Color.putih)
                .cornerRadius(15)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.gray.opacity(0.5))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        if !searchText.isEmpty {
                            Button { searchText = "" } label: {
                                Image(systemName: "xmark.circle.fill")
                                   .foregroundColor(.gray)
                                   .padding(.trailing, 8)
                            }
                        }
                    }
                )
        
            Menu {
                Picker("Select Chapter", selection: $selectedChapterIndex) {
                    ForEach(chapters.indices, id: \.self) { index in
                        Text("\(chapters[index].chapterName)")
                            .tag(index)
                    }
                }.pickerStyle(MenuPickerStyle())
            } label: {
                HStack {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(Color.gray.opacity(0.5))
                        .padding(12)
                        .background(Color.white)
                        .clipShape(Circle())
                }
            }
        }
    }
}

