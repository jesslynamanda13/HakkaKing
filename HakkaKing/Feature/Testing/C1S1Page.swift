//
//  C1S1Page.swift
//  HakkaKing
//
//  Created by Amanda on 15/06/25.
//


import AVFoundation
import SoundAnalysis
import SwiftUI
import CoreML

class AudioViewModel: NSObject, ObservableObject, SNResultsObserving  {
    @Published var confidenceResults: [String: Bool] = [:]
    @Published var currentIndex = 0
    
    private var audioEngine = AVAudioEngine()
    private var streamAnalyzer: SNAudioStreamAnalyzer?

    let words = ["an kiu", "mo", "nyi to", "nyi"]

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
        
        DispatchQueue.main.async {
            let expected = self.words[self.currentIndex]
            // confidence score
            if first.identifier == expected && first.confidence > 0.40 {
                
                self.confidenceResults[expected] = true
                if self.currentIndex < self.words.count - 1 {
                    self.currentIndex += 1
                }
            }
        }
    }
}

struct PronunciationView: View {
    @StateObject var viewModel = AudioViewModel()
    @State var isRecording = false
    
    let mlModel = try! Chapter1_Sentence1(configuration: MLModelConfiguration()).model
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Practice: An kiu mo nyi to nyi")
                .font(.title)

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
    }
}
