import AVFoundation
import SoundAnalysis
import SwiftUI
import CoreML

// ===================================================================
// 1. YOUR VIEWMODEL (CLASS 'Chapter1')
// This code is correct. No changes were needed here.
// ===================================================================
@MainActor
class Chapter1: NSObject, ObservableObject, SNResultsObserving {
    @Published var confidenceResults: [String: Bool] = [:]
    @Published var currentIndex = 0
    @Published var lastClassification = ""
    @Published var lastConfidence: Double = 0.0
    
    let sentence: [String]
    
    private var audioEngine = AVAudioEngine()
    private var streamAnalyzer: SNAudioStreamAnalyzer?

    init(sentence: [String]) {
        self.sentence = sentence
        super.init()
        
        for word in self.sentence {
            confidenceResults[word] = false
        }
    }
    
    func startRecording(model: MLModel) {
        currentIndex = 0
        for word in sentence {
            confidenceResults[word] = false
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to activate Audio Session: \(error.localizedDescription)")
            return
        }
        
        let input = audioEngine.inputNode
        let format = input.outputFormat(forBus: 0)

        streamAnalyzer = SNAudioStreamAnalyzer(format: format)

        do {
            let classifier = try SNClassifySoundRequest(mlModel: model)
            try streamAnalyzer?.add(classifier, withObserver: self)

            input.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, when in
                self.streamAnalyzer?.analyze(buffer, atAudioFramePosition: when.sampleTime)
            }
            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            print("Unable to start audio analysis: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        if audioEngine.isRunning {
            audioEngine.inputNode.removeTap(onBus: 0)
            audioEngine.stop()
        }
    }
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let classificationResult = result as? SNClassificationResult,
              let topClassification = classificationResult.classifications.first(where: { $0.identifier != "background_noises" })
        else { return }
        
        DispatchQueue.main.async {
            self.lastClassification = topClassification.identifier
            self.lastConfidence = topClassification.confidence
        }

        guard currentIndex < sentence.count else { return }

        let expectedWord = sentence[currentIndex]
        
        if topClassification.identifier == expectedWord && topClassification.confidence > 0.70 {
            print("Correctly identified '\(expectedWord)'")
            
            DispatchQueue.main.async {
                self.confidenceResults[expectedWord] = true
                if self.currentIndex < self.sentence.count - 1 {
                    self.currentIndex += 1
                }
            }
        }
    }
    
    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("Sound analysis failed: \(error.localizedDescription)")
    }
}

// ===================================================================
// 2. THE PARENT VIEW (Chapter1View)
// This view now handles picking the sentence.
// ===================================================================
struct Chapter1View: View {
    // Define your sentences
    let sentence1 = ["An Kiu", "Mo", "Nyi To", "Nyi"]
    let sentence2 = ["He wa", "BiongKa", "cang", "kin ha", "Ngai"]
    let sentence3 = ["Thuk Shu", "co she"]

    // State to track the current selection
    @State private var selectedSentence: [String]
    
    // Load your ML Model once
    let mlModel: MLModel

    init() {
        // Set the initial sentence for the picker
        _selectedSentence = State(initialValue: ["An Kiu", "Mo", "Nyi To", "Nyi"])
        
        do {
            // Make sure the model name here matches your file.
            mlModel = try Chapter1Classifier(configuration: MLModelConfiguration()).model
        } catch {
            fatalError("Failed to load Core ML model: \(error)")
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            Picker("Select a Sentence", selection: $selectedSentence) {
                Text("Sentence 1").tag(sentence1)
                Text("Sentence 2").tag(sentence2)
                Text("Sentence 3").tag(sentence3)
            }
            .pickerStyle(.segmented)
            
            // We create the child view here and pass it the selected sentence.
            Chapter1SessionView(sentence: selectedSentence, model: mlModel)
                // THE FIX: This .id() modifier tells SwiftUI to create a NEW
                // Chapter1SessionView whenever the sentence changes.
                .id(selectedSentence)
        }
        .padding()
    }
}

// ===================================================================
// 3. THE CHILD VIEW (Chapter1SessionView)
// This new view handles the actual practice session.
// ===================================================================
struct Chapter1SessionView: View {
    // This view now holds the StateObject, using the correct class name 'Chapter1'
    @StateObject private var viewModel: Chapter1
    
    @State private var isRecording = false
    
    // It receives the sentence and model from the parent view
    let sentence: [String]
    let model: MLModel
    
    init(sentence: [String], model: MLModel) {
        self.sentence = sentence
        self.model = model
        // We initialize the StateObject here, for this specific session
        _viewModel = StateObject(wrappedValue: Chapter1(sentence: sentence))
    }
    
    var body: some View {
        // The rest of your UI lives here, unchanged.
        VStack(spacing: 20) {
            Text("Practice: \(viewModel.sentence.joined(separator: " "))")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text("Current Target: \(viewModel.sentence[viewModel.currentIndex])")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.yellow.opacity(0.2))
                .cornerRadius(10)
            
            List {
                ForEach(viewModel.sentence, id: \.self) { word in
                    HStack {
                        Text(word)
                        Spacer()
                        if viewModel.confidenceResults[word] == true {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "circle")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .listStyle(.plain)
            
            Text("I hear: \(isRecording ? viewModel.lastClassification : "—") (\(String(format: "%.1f", viewModel.lastConfidence * 100))%)")
                 .font(.subheadline)
                 .padding()
                 .frame(maxWidth: .infinity)
                 .background(Color.gray.opacity(0.2))
                 .cornerRadius(10)

            Button(isRecording ? "Stop" : "Record") {
                isRecording.toggle()
                if isRecording {
                    viewModel.startRecording(model: model)
                } else {
                    viewModel.stopRecording()
                }
            }
            .padding()
            .frame(width: 200, height: 50)
            .background(isRecording ? Color.red : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .onDisappear {
            viewModel.stopRecording()
        }
    }
}

#Preview {
    Chapter1View()
}
