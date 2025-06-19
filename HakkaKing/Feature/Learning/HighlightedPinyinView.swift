// File: HighlightedPinyinView.swift
import SwiftUI

struct HighlightedPinyinView: View {
    let words: [Word]
    let analysisResult: [String: Bool]

    // Kamus baru dengan kunci huruf kecil untuk pencocokan case-insensitive
    private var lowercasedResult: [String: Bool] {
        Dictionary(uniqueKeysWithValues: analysisResult.map { key, value in
            (key.lowercased(), value)
        })
    }
    
    @State private var totalHeight: CGFloat = .zero

    var body: some View {
        // Menggunakan GeometryReader untuk layout wrapping yang dinamis
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)
    }
//    private func generateContent(in g: GeometryProxy) -> some View {
//        FlowLayout(data: words, spacing: 2) { word in
//            item(for: word)
//        }
//        .background(viewHeightReader($totalHeight))
//    }


    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(self.words) { word in
                item(for: word)
                    .padding(.all, 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if word.id == self.words.last?.id {
                            width = 0 // Reset
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { d in
                        let result = height
                        if word.id == self.words.last?.id {
                            height = 0 // Reset
                        }
                        return result
                    })
            }
        }.background(viewHeightReader($totalHeight))
    }

    private func item(for word: Word) -> some View {
        Text(word.pinyin)
            .fontWeight(.bold)
            .font(.title2)
            .fixedSize()
            .foregroundColor(colorFor(pinyin: word.pinyin))
    }

    // Fungsi pewarnaan sekarang case-insensitive
    private func colorFor(pinyin: String) -> Color {
        guard let isCorrect = lowercasedResult[pinyin.lowercased()] else {
            return .primary
        }
        return isCorrect ? .black : .black.opacity(0.5)
    }
    
    // Helper untuk mengukur tinggi konten secara dinamis
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            if rect.size.height != binding.wrappedValue {
                DispatchQueue.main.async {
                    binding.wrappedValue = rect.size.height
                }
            }
            return .clear
        }
    }
}
