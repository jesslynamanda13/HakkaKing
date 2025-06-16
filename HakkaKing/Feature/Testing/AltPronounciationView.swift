//
//  AltPronounciationView.swift
//  HakkaKing
//
//  Created by Amanda on 15/06/25.
//

import AVFoundation
import SoundAnalysis
import SwiftUI
import CoreML

@MainActor
class AltAudioViewModel: NSObject, ObservableObject, SNResultsObserving  {
    @Published var confidenceResults: [String: Bool] = [:]
    @Published var currentIndex = 0
    @Published var lastClassification = ""
    @Published var lastConfidence: Double = 0.0
    
    private var audioEngine = AVAudioEngine()
    private var streamAnalyzer: SNAudioStreamAnalyzer?

    let words = ["an kiu", "mo", "nyi to", "nyi"]

    override init() {
        super.init()
        for word in words {
            confidenceResults[word] = false
        }
    }
  
    func startRecording(model: MLModel) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to activate Audio Session.")
            return
        }
        
        let input = audioEngine.inputNode
        let format = input.outputFormat(forBus: 0)

        streamAnalyzer = SNAudioStreamAnalyzer(format: format)

        do {
            let classifier = try SNClassifySoundRequest(mlModel: model)
            try streamAnalyzer?.add(classifier, withObserver: self)

            let bus = 0
            input.installTap(onBus: bus, bufferSize: 1024, format: format) { buffer, when in
                self.streamAnalyzer?.analyze(buffer, atAudioFramePosition: when.sampleTime)
            }
            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            print("Unable to create classifier.")
        }
    }
    
    func stopRecording() {
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
    }
    
    // MARK: - SNResultsObserving
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let classification = result as? SNClassificationResult,
              let first = classification.classifications.max(by: { $0.confidence < $1.confidence })
        else { return }
        
        lastClassification = first.identifier
        lastConfidence = first.confidence

        let expected = words[currentIndex]
        if first.identifier == expected && first.confidence > 0.60 {
            print("Checking if correct...")
            confidenceResults[expected] = true


            if currentIndex < words.count - 1 {
                currentIndex += 1
            }
        }
    }

}


struct AltPronunciationView: View {
    @StateObject var viewModel = AltAudioViewModel()
    @State var isRecording = false
    
    let mlModel = try! Chapter1Sentence1(configuration: MLModelConfiguration()).model
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Practice: An kiu mo nyi to nyi")
                .font(.title)

            Text("Current Target: \(viewModel.words[viewModel.currentIndex])")
                           .font(.headline)
                           .padding()
                           .frame(maxWidth: .infinity)
                           .background(Color.yellow.opacity(0.2))
                           .cornerRadius(10)
            List {
                ForEach(0..<viewModel.words.count, id: \.self) { i in
                    HStack {
                        Text(viewModel.words[i])
                        Spacer()
                        if viewModel.confidenceResults[viewModel.words[i]] == true {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                        } else {
                           
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
  
            // NEW: show last classified label in real time
            // Inside your view's body:
            if viewModel.lastConfidence > 0.8 {
                Text("Last Prediction: \(viewModel.lastClassification) \(String(format: "%.2f", viewModel.lastConfidence))")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            } else {
                Text("Last Prediction: —")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }


            Button(isRecording ? "Stop" : "Record") {
                isRecording.toggle()
                
                if isRecording {
                    viewModel.startRecording(model: mlModel)
                } else {
                    viewModel.stopRecording()
                }
            }
            .padding()
            .frame(width: 200, height: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}
