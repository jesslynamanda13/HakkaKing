//
//  WrappinHStack.swift
//  HakkaKing
//
//  Created by Amanda on 13/06/25.
//

import SwiftUI

struct WrappingHStack<Content: View>: View {
    let spacing: CGFloat
    let alignment: VerticalAlignment
    let content: () -> Content

    init(spacing: CGFloat = 8, alignment: VerticalAlignment = .center, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.alignment = alignment
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }

    func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            content()
                .fixedSize() // prevent unwanted line breaks
                .alignmentGuide(.leading) { d in
                    if abs(width - d.width) > geometry.size.width {
                        width = 0
                        height -= d.height + spacing
                    }
                    let result = width
                    if d.width != 0 {
                        width += d.width + spacing
                    }
                    return -result
                }
                .alignmentGuide(.top) { _ in
                    let result = height
                    return -result
                }
        }
        .frame(width: geometry.size.width, alignment: .leading)
    }
}
