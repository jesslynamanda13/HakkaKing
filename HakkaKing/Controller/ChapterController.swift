import Foundation
import SwiftData
import AVFoundation
import CoreML

class ChapterController {
    let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchChapters() -> [Chapter] {
        let descriptor = FetchDescriptor<Chapter>(sortBy: [SortDescriptor(\.orderIndex)])
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Failed to fetch chapters: \(error)")
            return []
        }
    }

    func fetchChapterSentences(for chapter: Chapter, context: ModelContext) -> [Sentence] {
        do {
            let allSentences = try context.fetch(FetchDescriptor<Sentence>(sortBy: [SortDescriptor(\.orderIndex, order: .forward)]))
            let sentences = allSentences
                .filter { chapter.sentences.contains($0.id) }
                .sorted { $0.orderIndex < $1.orderIndex }
            return sentences
        } catch {
            print("Error fetching sentences: \(error)")
            return []
        }
    }
    func fetchSentences(for chapter: Chapter) -> [Sentence] {
        return chapter.sentences?.sorted { $0.orderIndex < $1.orderIndex } ?? []
    }
    
    //================================================================================
    // THIS IS THE TWO 'fetchWords' FUNCTIONS. BOTH ARE NEEDED.
    //================================================================================

    /// **Function 1: For the VOCABULARY screen.**
    /// Fetches all unique words associated with an entire chapter.
    func fetchWords(forChapter chapter: Chapter) -> [Word] {
        var wordsInChapter = Set<Word>()
        
        // Get all sentences for the chapter
        let sentences = self.fetchSentences(for: chapter)
        
        // For each sentence, get its words and add them to our set
        for sentence in sentences {
            let wordsForSentence = self.fetchWords(for: sentence)
            wordsInChapter.formUnion(wordsForSentence)
        }
        
        // Return the unique words as a sorted array
        return Array(wordsInChapter).sorted { $0.pinyin < $1.pinyin }
    }

    
    /// **Function 2: For the PRONUNCIATION PRACTICE screen.**
    /// Fetches the words for a single sentence, in the correct order.
    func fetchWords(for sentence: Sentence) -> [Word] {
        do {
            let allSentenceWords = try context.fetch(FetchDescriptor<SentenceWord>())
            let relatedSentenceWords = allSentenceWords
                .filter { $0.sentenceID == sentence.id }
                .sorted { $0.position < $1.position }
            
            let allWords = try context.fetch(FetchDescriptor<Word>())
            
            let wordsForSentence = relatedSentenceWords.compactMap { sentenceWord in
                allWords.first { $0.id == sentenceWord.wordID }
            }
            return wordsForSentence
        } catch {
            print("Error fetching words for sentence \(sentence.pinyin): \(error)")
            return []
        }
    }

    //================================================================================
    // BACKLOG IMPLEMENTATION REMAINS THE SAME
    //================================================================================

    @MainActor
    func checkPronunciation(for sentence: Sentence) async -> (result: [String: Bool]?, error: Error?) {
        guard let chapter = sentence.chapter else {
            print("Error: Sentence \(sentence.pinyin) has no associated chapter.")
            return (nil, NSError(domain: "DataConsistencyError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Sentence has no chapter"]))
        }
        
        let words = fetchWords(for: sentence)
        guard !words.isEmpty else {
            print("No words found for this sentence.")
            return (nil, nil)
        }
        let wordPinyins = words.map { $0.pinyin }
        
        guard let model = loadMLModel(chapterIndex: chapter.orderIndex, sentenceIndex: sentence.orderIndex) else {
            print("ML Model not found for Chapter \(chapter.orderIndex) Sentence \(sentence.orderIndex)")
            return (nil, NSError(domain: "ModelLoadingError", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Could not load ML Model"]))
        }
        
        let analyser = PronunciationAnalyser(words: wordPinyins, model: model)
        
        do {
            let analysisResult = try await analyser.analyze()
            return (analysisResult, nil)
        } catch {
            print("Pronunciation analysis failed with error: \(error)")
            return (nil, error)
        }
    }
    
    func evaluateScore(from result: [String: Bool]) -> Double {
        let correctCount = result.values.filter { $0 == true }.count
        let totalCount = result.keys.count
        guard totalCount > 0 else { return 0.0 }
        return (Double(correctCount) / Double(totalCount)) * 100.0
    }
    
    func loadMLModel(chapterIndex: Int, sentenceIndex: Int) -> MLModel? {
        do {
            switch (chapterIndex, sentenceIndex) {
            case (1, 1): return try Chapter1Sentence1(configuration: .init()).model
            case (1, 2): return try Chapter1Sentence2(configuration: .init()).model
            case (1, 3): return try Chapter1Sentence3(configuration: .init()).model
            case (1, 4): return try Chapter1Sentence4(configuration: .init()).model
            case (2, 1): return try Chapter2Sentence1(configuration: .init()).model
            case (2, 2): return try Chapter2Sentence2(configuration: .init()).model
            case (2, 3): return try Chapter2Sentence3(configuration: .init()).model
            case (2, 4): return try Chapter2Sentence4(configuration: .init()).model
            case (3, 1): return try Chapter3Sentence1(configuration: .init()).model
            case (3, 2): return try Chapter3Sentence2(configuration: .init()).model
            case (3, 3): return try Chapter3Sentence3(configuration: .init()).model
            case (3, 4): return try Chapter3Sentence4(configuration: .init()).model
            default:
                print("No matching ML Model for Chapter \(chapterIndex), Sentence \(sentenceIndex)")
                return nil
            }
        } catch {
            print("Error loading ML model: \(error)")
            return nil
        }
    }
}
