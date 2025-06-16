//
//  ChapterCard.swift
//  HakkaApp
//
//  Created by Marshia on 13/06/25.
//

import SwiftUI

struct ChapterCard: View {
    let chapter: Chapter
    let index: Int
    
    var body: some View {
        HStack(spacing: 16) {
            Image(chapter.coverImage)
                .resizable()
                .scaledToFit()
                .frame(width: 113, height: 114)
                .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Chapter \(chapter.orderIndex)")
                    .font(.system(size: 14).weight(.bold))
                    .foregroundColor(.dark)
                Text(chapter.chapterName)
                    .font(.system(size: 12).weight(.bold))
                    .foregroundColor(.dark)
                Text(chapter.chapterDescription)
                    .font(.system(size: 12))
                    .foregroundColor(.dark)
//                    .lineLimit(2)
                    .padding(.bottom, 10)
                
                
                
                HStack{
                    // Mulai Button
                    Spacer()
                    Button(action: {
                        // Add navigation or action here (e.g., to SentenceListView)
                    }) {
                        Text("Mulai")
                            .fontWeight(.bold)
                            .font(.system(size: 14).weight(.bold))
                            .foregroundColor(.putih)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 39)
                            .background(.oren)
                            .cornerRadius(15)
                    }
                    .shadow(color: Color.black.opacity(0.25), radius: 0, x: 0, y: 2)
                    Spacer()
                }
            }

            
            
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 12)
//        .frame(maxWidth: 350, maxHeight: 150)
        .background(.putih)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.orangeBorder, lineWidth: 2)
        )
    }
}

