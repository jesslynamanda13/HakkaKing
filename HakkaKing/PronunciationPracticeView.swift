////
////  PronounciationPracticeView.swift // Renamed for clarity
////  HakkaKing
////
////  Created by Amanda on 15/06/25.
////
//
//import AVFoundation
//import SoundAnalysis
//import SwiftUI
//import CoreML
//
//@MainActor
//class HakkaAudioViewModel: NSObject, ObservableObject, SNResultsObserving { // Renamed for clarity
//    @Published var confidenceResults: [String: Bool] = [:]
//    @Published var currentIndex = 0
//    @Published var lastClassification = ""
//    @Published var lastConfidence: Double = 0.0
//    
//    private var audioEngine = AVAudioEngine()
//    private var streamAnalyzer: SNAudioStreamAnalyzer?
//
//    // CHANGED: Updated the words array to match your C1S2 data
//    let words = ["He wa", "BiongKa", "cang", "kin ha", "Ngai"]
//
//    override init() {
//        super.init()
//        // Initialize confidence for each word
//        for word in words {
//            confidenceResults[word] = false
//        }
//    }
//    
//    func startRecording(model: MLModel) {
//        // Reset state for a new recording session
//        currentIndex = 0
//        for word in words {
//            confidenceResults[word] = false
//        }
//        
//        do {
//            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [])
//            try AVAudioSession.sharedInstance().setActive(true)
//        } catch {
//            print("Failed to activate Audio Session: \(error.localizedDescription)")
//            return
//        }
//        
//        let input = audioEngine.inputNode
//        let format = input.outputFormat(forBus: 0)
//
//        streamAnalyzer = SNAudioStreamAnalyzer(format: format)
//
//        do {
//            let classifier = try SNClassifySoundRequest(mlModel: model)
//            try streamAnalyzer?.add(classifier, withObserver: self)
//
//            let bus = 0
//            input.installTap(onBus: bus, bufferSize: 1024, format: format) { buffer, when in
//                self.streamAnalyzer?.analyze(buffer, atAudioFramePosition: when.sampleTime)
//            }
//            audioEngine.prepare()
//            try audioEngine.start()
//        } catch {
//            print("Unable to start audio analysis: \(error.localizedDescription)")
//        }
//    }
//    
//    func stopRecording() {
//        if audioEngine.isRunning {
//            audioEngine.inputNode.removeTap(onBus: 0)
//            audioEngine.stop()
//        }
//    }
//    
//    // MARK: - SNResultsObserving
//    
//    func request(_ request: SNRequest, didProduce result: SNResult) {
//        guard let classificationResult = result as? SNClassificationResult,
//              let topClassification = classificationResult.classifications.max(by: { $0.confidence < $1.confidence })
//        else { return }
//        
//        // Update the UI in real-time
//        DispatchQueue.main.async {
//            self.lastClassification = topClassification.identifier
//            self.lastConfidence = topClassification.confidence
//        }
//
//        // Check if we are still waiting for a word
//        guard currentIndex < words.count else { return }
//
//        let expectedWord = words[currentIndex]
//        
//        // Check if the model identified the correct word with high confidence
//        if topClassification.identifier == expectedWord && topClassification.confidence > 0.80 { // Increased confidence for better accuracy
//            print("Correctly identified '\(expectedWord)' with confidence \(topClassification.confidence)")
//            
//            DispatchQueue.main.async {
//                self.confidenceResults[expectedWord] = true
//                
//                // Move to the next word
//                if self.currentIndex < self.words.count - 1 {
//                    self.currentIndex += 1
//                } else {
//                    // Optional: Stop recording automatically after the last word is said
//                    // self.stopRecording()
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
//
//struct PronunciationPracticeView: View { // Renamed for clarity
//    @StateObject var viewModel = HakkaAudioViewModel()
//    @State var isRecording = false
//    
//    // CHANGED: Load your new model here. Replace "HakkaWordClassifier" with the actual name you gave your .mlmodel file.
//    let mlModel: MLModel
//    
//    init() {
//        do {
//            mlModel = try HakkaWordClassifier(configuration: MLModelConfiguration()).model
//        } catch {
//            fatalError("Failed to load Core ML model: \(error)")
//        }
//    }
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            // CHANGED: Updated the title to your sentence
//            Text("Practice: He wa BiongKa cang kin ha Ngai")
//                .font(.title)
//                .multilineTextAlignment(.center)
//
//            Text("Current Target: \(viewModel.words[viewModel.currentIndex])")
//                .font(.headline)
//                .padding()
//                .frame(maxWidth: .infinity)
//                .background(Color.yellow.opacity(0.2))
//                .cornerRadius(10)
//            
//            List {
//                ForEach(viewModel.words, id: \.self) { word in
//                    HStack {
//                        Text(word)
//                        Spacer()
//                        if viewModel.confidenceResults[word] == true {
//                            Image(systemName: "checkmark.circle.fill")
//                                .foregroundColor(.green)
//                        } else {
//                            Image(systemName: "circle")
//                                .foregroundColor(.gray)
//                        }
//                    }
//                }
//            }
//            .listStyle(.plain)
//            
//            // Real-time feedback
//            Text("I hear: \(isRecording ? viewModel.lastClassification : "—") (\(String(format: "%.1f", viewModel.lastConfidence * 100))%)")
//                 .font(.subheadline)
//                 .padding()
//                 .frame(maxWidth: .infinity)
//                 .background(Color.gray.opacity(0.2))
//                 .cornerRadius(10)
//
//            Button(isRecording ? "Stop" : "Record") {
//                isRecording.toggle()
//                
//                if isRecording {
//                    viewModel.startRecording(model: mlModel)
//                } else {
//                    viewModel.stopRecording()
//                }
//            }
//            .padding()
//            .frame(width: 200, height: 50)
//            .background(isRecording ? Color.red : Color.blue)
//            .foregroundColor(.white)
//            .cornerRadius(10)
//        }
//        .padding()
//        .onDisappear {
//            // Make sure to stop recording when the view disappears
//            viewModel.stopRecording()
//        }
//    }
//}
//
//#Preview {
//    PronunciationPracticeView()
//}
