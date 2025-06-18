import Foundation
import SwiftData
import AVFoundation
import CoreML
import SoundAnalysis

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
    //    func fetchSentences(for chapter: Chapter) -> [Sentence] {
    //        return chapter.sentences?.sorted { $0.orderIndex < $1.orderIndex } ?? []
    //    }
    //
    //    //================================================================================
    //    // THIS IS THE TWO 'fetchWords' FUNCTIONS. BOTH ARE NEEDED.
    //    //================================================================================
    //
    //    /// **Function 1: For the VOCABULARY screen.**
    //    /// Fetches all unique words associated with an entire chapter.
    //    func fetchWords(forChapter chapter: Chapter) -> [Word] {
    //        var wordsInChapter = Set<Word>()
    //
    //        // Get all sentences for the chapter
    //        let sentences = self.fetchSentences(for: chapter)
    //
    //        // For each sentence, get its words and add them to our set
    //        for sentence in sentences {
    //            let wordsForSentence = self.fetchWords(for: sentence)
    //            wordsInChapter.formUnion(wordsForSentence)
    //        }
    //
    //        // Return the unique words as a sorted array
    //        return Array(wordsInChapter).sorted { $0.pinyin < $1.pinyin }
    //    }
    //
    //
    //    /// **Function 2: For the PRONUNCIATION PRACTICE screen.**
    //    /// Fetches the words for a single sentence, in the correct order.
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
    
    func fetchWordsPerChapter(chapter: Chapter) -> [Word] {
        do {
            let allSentences = try context.fetch(FetchDescriptor<Sentence>())
            let chapterSentences = allSentences
                .filter { chapter.sentences.contains($0.id) }
            
            let sentenceIDs = chapterSentences.map { $0.id }
            
            let allSentenceWords = try context.fetch(FetchDescriptor<SentenceWord>())
            let relatedSentenceWords = allSentenceWords
                .filter { sentenceIDs.contains($0.sentenceID) }
            
            let wordIDs = Set(relatedSentenceWords.map { $0.wordID })
            
            let allWords = try context.fetch(FetchDescriptor<Word>())
            let words = allWords.filter { wordIDs.contains($0.id) }
            
            return words
        } catch {
            print("Error fetching words for chapter \(chapter.chapterName): \(error)")
            return []
        }
    }
    
    //================================================================================
    // BACKLOG IMPLEMENTATION: [BE] Create checkPronounciation function
    //================================================================================
    // CATATAN: Fungsi ini tampaknya untuk analisis real-time, dan mungkin tidak akan diubah banyak
    // untuk fitur highlight per-kata ini karena kita akan fokus pada analyzePronunciation(fromAudioFile:...)
    // yang menggunakan ResultsObserver.
    @MainActor
    func checkPronunciation(for sentence: Sentence, in chapter: Chapter) async -> (result: [String: Bool]?, error: Error?) {
        let words = fetchWords(for: sentence)
        guard !words.isEmpty else {
            print("No words found for this sentence.")
            return (nil, nil)
        }
        let wordPinyins = words.map { $0.pinyin }
        
        // This now uses the 'chapter' parameter, which is safe.
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
    
    /// Calculates the score from a pronunciation result.
    func evaluateScore(from result: [String: Bool]) -> Double {
        let correctCount = result.values.filter { $0 == true }.count
        let totalCount = result.keys.count
        guard totalCount > 0 else { return 0.0 }
        return (Double(correctCount) / Double(totalCount)) * 100.0
    }
    
    /// Loads the correct .mlmodel file based on the chapter and sentence index.
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
    
    // Ini adalah fungsi utama untuk analisis file audio dan akan dimodifikasi
    @MainActor
    func analyzePronunciation(fromAudioFile audioURL: URL, for sentence: Sentence, in chapter: Chapter) async -> (result: [String: Bool]?, error: Error?) {
        
        // 1. Siapkan data kata dan model ML
        let words = fetchWords(for: sentence)
        guard !words.isEmpty else { return (nil, nil) }
        
        // Buat daftar pinyin yang "bersih" untuk perbandingan (tanpa kapitalisasi, dll.)
        // Sesuaikan dengan bagaimana model ML Anda mengenali kata-kata.
        let wordPinyins = words.map { $0.pinyin.lowercased().trimmingCharacters(in: .punctuationCharacters) }
        
        guard let model = loadMLModel(chapterIndex: chapter.orderIndex, sentenceIndex: sentence.orderIndex) else {
            return (nil, NSError(domain: "ModelLoadingError", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Could not load ML Model"]))
        }
        
        // 2. Gunakan SNAudioFileAnalyzer untuk menganalisis file audio
        do {
            let fileAnalyzer = try SNAudioFileAnalyzer(url: audioURL)
            let request = try SNClassifySoundRequest(mlModel: model)
            
            // Buat observer untuk menangkap hasil analisis
            // Melewatkan semua kata pinyin yang diharapkan
            let resultsObserver = ResultsObserver(wordsToPractice: wordPinyins)
            try fileAnalyzer.add(request, withObserver: resultsObserver)
            
            // Mulai analisis file
            try await fileAnalyzer.analyze()
            
            // Kembalikan hasil dari observer setelah analisis selesai
            return (resultsObserver.finalResults, nil)
            
        } catch {
            print("Audio file analysis failed: \(error)")
            return (nil, error)
        }
    }
    
    // Ubah class helper KECIL ini di dalam file yang sama (ChapterController.swift), TAPI DI LUAR class ChapterController
    @MainActor
    private class ResultsObserver: NSObject, SNResultsObserving {
        var finalResults: [String: Bool] // Ini akan menyimpan status benar/salah untuk setiap kata pinyin
        private let wordsToPractice: [String] // Daftar kata pinyin yang diharapkan, sudah bersih/lowercase
        
        init(wordsToPractice: [String]) {
            self.wordsToPractice = wordsToPractice
            // Inisialisasi semua kata sebagai false pada awalnya
            self.finalResults = Dictionary(uniqueKeysWithValues: wordsToPractice.map { ($0, false) })
            super.init()
        }
        
        func request(_ request: SNRequest, didProduce result: SNResult) {
            guard let result = result as? SNClassificationResult else { return }
            
            // Iterasi melalui semua klasifikasi yang dihasilkan oleh model
            for classification in result.classifications {
                // Abaikan background noises
                if classification.identifier == "background_noises" { continue }
                
                // Bersihkan identifier dari model jika perlu (misalnya, lowercase)
                let recognizedIdentifier = classification.identifier.lowercased().trimmingCharacters(in: .punctuationCharacters)
                
                // Periksa apakah identifier model cocok dengan salah satu kata yang kita latih
                if wordsToPractice.contains(recognizedIdentifier) {
                    // Jika kata ini belum ditandai benar dan confidence-nya tinggi
                    // Anda bisa menyesuaikan ambang batas kepercayaan (e.g., 0.75)
                    if finalResults[recognizedIdentifier] == false && classification.confidence > 0.60 {
                        print("File Analyser identified: \(recognizedIdentifier) with confidence: \(classification.confidence)")
                        finalResults[recognizedIdentifier] = true
                    }
                }
            }
        }
        
        func request(_ request: SNRequest, didFailWithError error: Error) {
            print("File-based analysis request failed: \(error)")
        }
        
        func requestDidComplete(_ request: SNRequest) {
            print("File analysis complete. Final Results: \(finalResults)")
        }
        
    }
}
