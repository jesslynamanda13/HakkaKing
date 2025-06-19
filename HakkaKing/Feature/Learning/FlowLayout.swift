//
//  FlowLayout.swift
//  HakkaKing
//
//  Created by Amanda on 19/06/25.
//

import SwiftUI

struct FlowLayout<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    let data: Data
    let spacing: CGFloat
    let content: (Data.Element) -> Content

    init(data: Data, spacing: CGFloat = 8, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width: CGFloat = 0
        var rows: [[Data.Element]] = [[]]
        
        for item in data {
            let itemSize = CGSize(width: 80, height: 30) // Perkiraan ukuran
            if width + itemSize.width + spacing > g.size.width {
                width = 0
                rows.append([])
            }
            rows[rows.count - 1].append(item)
            width += itemSize.width + spacing
        }

        return VStack(alignment: .center, spacing: spacing) {
            ForEach(0..<rows.count, id: \.self) { rowIndex in
                HStack(spacing: spacing) {
                    ForEach(rows[rowIndex]) { item in
                        content(item)
                    }
                }
            }
        }
        .frame(width: g.size.width)
    }
}
