////
////  HakkaPracticeFlow.swift
////  HakkaKing
////
////  Created by Richard WIjaya Harianto on 16/06/25.
////
//
//import SwiftUI
//import SwiftData
//import CoreML
//import AVFoundation
//import SoundAnalysis
//
//// VIEW 1: CHAPTER LIST (Your entry point)
//struct ChapterView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query(sort: \Chapter.orderIndex) var chapters: [Chapter]
//    
//    var body: some View {
//        NavigationStack {
//            List(chapters) { chapter in
//                NavigationLink(destination: SentenceListView(chapter: chapter)) {
//                    VStack(alignment: .leading) {
//                        Text(chapter.chapterName)
//                            .font(.headline)
//                        Text(chapter.chapterDescription)
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                    }
//                }
//            }
//            .navigationTitle("Chapters")
//        }
//    }
//}
//
//// VIEW 2: SENTENCE LIST
//struct SentenceListView: View {
//    @Environment(\.modelContext) private var modelContext
//    let chapter: Chapter
//    
//    // The controller is created here to manage data for this screen
//    private var controller: ChapterController {
//        ChapterController(context: modelContext)
//    }
//    
//    var body: some View {
//        // Fetches sentences directly from the chapter's relationship
//        let sentences = controller.fetchSentences(for: chapter)
//        
//        List(sentences) { sentence in
//            NavigationLink(destination: PronunciationPracticeView(
//                controller: controller,
//                sentence: sentence
//            )) {
//                VStack(alignment: .leading) {
//                    Text("Sentence \(sentence.orderIndex)")
//                        .font(.headline)
//                    Text(sentence.pinyin)
//                        .font(.subheadline)
//                    Text(sentence.translation)
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                }
//            }
//        }
//        .navigationTitle(chapter.chapterName)
//    }
//}
//
//// VIEW 3: PRONUNCIATION PRACTICE (The screen that prepares and shows the practice UI)
//struct PronunciationPracticeView: View {
//    let controller: ChapterController
//    let sentence: Sentence
//    
//    // State for the data needed by the practice UI
//    @State private var sessionData: (pinyins: [String], model: MLModel)?
//    @State private var isLoading = true
//    @State private var errorMessage: String?
//    
//    var body: some View {
//        VStack {
//            if isLoading {
//                ProgressView("Preparing Practice...")
//            } else if let data = sessionData {
//                PracticeSessionView(sentence: data.pinyins, model: data.model)
//            } else if let error = errorMessage {
//                ContentUnavailableView("Error", systemImage: "xmark.octagon", description: Text(error))
//            }
//        }
//        .navigationTitle("Practice Sentence \(sentence.orderIndex)")
//        .navigationBarTitleDisplayMode(.inline)
//        .task { // .task runs automatically when the view appears
//            // Ensure we are not already loading
//            guard isLoading else { return }
//            
//            // 1. Check for chapter
//            guard let chapter = sentence.chapter else {
//                self.errorMessage = "Data Error: Sentence is not linked to a chapter."
//                self.isLoading = false
//                return
//            }
//            
//            // 2. Fetch words
//            let words = controller.fetchWords(for: sentence)
//            guard !words.isEmpty else {
//                self.errorMessage = "Data Error: No words found for this sentence."
//                self.isLoading = false
//                return
//            }
//            
//            // 3. Load ML model
//            guard let model = controller.loadMLModel(chapterIndex: chapter.orderIndex, sentenceIndex: sentence.orderIndex) else {
//                self.errorMessage = "ML Model for Chapter \(chapter.orderIndex), Sentence \(sentence.orderIndex) could not be loaded. Make sure the file is in the project."
//                self.isLoading = false
//                return
//            }
//            
//            // 4. All data is ready, set the session data
//            self.sessionData = (words.map { $0.pinyin }, model)
//            self.isLoading = false
//        }
//    }
//}
//
//// VIEW 4: THE ACTUAL PRACTICE UI
//struct PracticeSessionView: View {
//    @StateObject private var viewModel: AudioAnalysisViewModel
//    @State private var isRecording = false
//    
//    let model: MLModel
//    
//    init(sentence: [String], model: MLModel) {
//        self.model = model
//        _viewModel = StateObject(wrappedValue: AudioAnalysisViewModel(sentence: sentence))
//    }
//    
//    var body: some View {
//        VStack(spacing: 15) {
//            Text("Practice:")
//                .font(.subheadline).foregroundColor(.secondary)
//            Text(viewModel.sentence.joined(separator: " "))
//                .font(.title3).bold().multilineTextAlignment(.center).padding(.horizontal)
//            
//            List {
//                Text("Current Target: \(viewModel.sentence[viewModel.currentIndex])")
//                    .font(.headline).frame(maxWidth: .infinity, alignment: .center)
//                    .listRowBackground(Color.yellow.opacity(0.2))
//                
//                ForEach(viewModel.sentence, id: \.self) { word in
//                    HStack {
//                        Text(word)
//                        Spacer()
//                        if viewModel.confidenceResults[word] == true {
//                            Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
//                        } else {
//                            Image(systemName: "circle").foregroundColor(.gray)
//                        }
//                    }
//                }
//            }.listStyle(.plain)
//            
//            Text("I hear: \(isRecording ? viewModel.lastClassification : "—") (\(String(format: "%.0f", viewModel.lastConfidence * 100))%)")
//                .font(.subheadline)
//            
//            Button(isRecording ? "Stop Recording" : "Record") {
//                isRecording.toggle()
//                if isRecording { viewModel.startRecording(model: model) }
//                else { viewModel.stopRecording() }
//            }
//            .font(.headline).padding().frame(maxWidth: .infinity)
//            .background(isRecording ? Color.red : Color.blue).foregroundColor(.white)
//            .cornerRadius(12)
//        }
//        .padding()
//        .onDisappear { viewModel.stopRecording() }
//    }
//}
//
//// THE VIEWMODEL FOR THE UI
//@MainActor
//class AudioAnalysisViewModel: NSObject, ObservableObject, SNResultsObserving {
//    @Published var confidenceResults: [String: Bool]
//    @Published var currentIndex = 0
//    @Published var lastClassification = ""
//    @Published var lastConfidence: Double = 0.0
//    
//    let sentence: [String]
//    private var audioEngine = AVAudioEngine()
//    private var streamAnalyzer: SNAudioStreamAnalyzer?
//    
//    init(sentence: [String]) {
//        self.sentence = sentence
//        self.confidenceResults = Dictionary(uniqueKeysWithValues: sentence.map { ($0, false) })
//        super.init()
//    }
//    
//    func startRecording(model: MLModel) {
//        currentIndex = 0
//        confidenceResults = Dictionary(uniqueKeysWithValues: sentence.map { ($0, false) })
//        
//        do {
//            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [])
//            try AVAudioSession.sharedInstance().setActive(true)
//        } catch { print("Failed to activate Audio Session: \(error.localizedDescription)"); return }
//        
//        let input = audioEngine.inputNode
//        let format = input.outputFormat(forBus: 0)
//        streamAnalyzer = SNAudioStreamAnalyzer(format: format)
//        
//        do {
//            let request = try SNClassifySoundRequest(mlModel: model)
//            try streamAnalyzer?.add(request, withObserver: self)
//            input.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
//                self.streamAnalyzer?.analyze(buffer, atAudioFramePosition: 0)
//            }
//            audioEngine.prepare()
//            try audioEngine.start()
//        } catch { print("Unable to start audio analysis: \(error.localizedDescription)") }
//    }
//    
//    func stopRecording() {
//        if audioEngine.isRunning {
//            audioEngine.inputNode.removeTap(onBus: 0)
//            audioEngine.stop()
//        }
//    }
//    
//    func request(_ request: SNRequest, didProduce result: SNResult) {
//        guard let classificationResult = result as? SNClassificationResult,
//              let topClassification = classificationResult.classifications.first(where: { $0.identifier != "background_noises" })
//        else { return }
//        
//        DispatchQueue.main.async {
//            self.lastClassification = topClassification.identifier
//            self.lastConfidence = topClassification.confidence
//        }
//        
//        guard currentIndex < sentence.count else { return }
//        let expectedWord = sentence[currentIndex]
//        
//        if topClassification.identifier == expectedWord && topClassification.confidence > 0.75 {
//            print("Correctly identified '\(expectedWord)'")
//            DispatchQueue.main.async {
//                if self.confidenceResults[expectedWord] == false {
//                    self.confidenceResults[expectedWord] = true
//                    if self.currentIndex < self.sentence.count - 1 {
//                        self.currentIndex += 1
//                    }
//                }
//            }
//        }
//    }
//    
//    func request(_ request: SNRequest, didFailWithError error: Error) {
//        print("Sound analysis failed: \(error.localizedDescription)")
//    }
//}
//
//// THE PREVIEW CODE THAT WORKS
//#Preview {
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: Chapter.self, Sentence.self, Word.self, SentenceWord.self, configurations: config)
//        
//        seedChapter1(context: container.mainContext)
//        seedChapter2(context: container.mainContext)
//        seedChapter3(context: container.mainContext)
//        
//        return ChapterView()
//            .modelContainer(container)
//        
//    } catch {
//        return Text("Failed to create preview container: \(error.localizedDescription)")
//    }
//}
