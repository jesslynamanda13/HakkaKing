//
//  PronunciationAnalyzer.swift
//  HakkaKing
//
//  Created by Richard WIjaya Harianto on 16/06/25.
//

// PronunciationAnalyser.swift

import Foundation
import AVFoundation
import SoundAnalysis
import CoreML

// Class ini bertugas untuk melakukan satu sesi analisis pengucapan.
// Dibuat untuk menjadi 'single-use' dan mengembalikan hasil secara asynchronous.
@MainActor
class PronunciationAnalyser: NSObject, SNResultsObserving {
    
    private var streamAnalyzer: SNAudioStreamAnalyzer?
    private let audioEngine = AVAudioEngine()
    
    private let wordsToPractice: [String]
    private let mlModel: MLModel
    
    // Continuation untuk 'menjembatani' antara proses callback delegate dan async/await.
    private var analysisContinuation: CheckedContinuation<[String: Bool], Error>?
    
    // State internal untuk melacak progres
    private var confidenceResults: [String: Bool]
    private var currentIndex = 0

    init(words: [String], model: MLModel) {
        self.wordsToPractice = words
        self.mlModel = model
        self.confidenceResults = Dictionary(uniqueKeysWithValues: words.map { ($0, false) })
        super.init()
    }

    // Fungsi utama yang dipanggil dari luar.
    // Mengembalikan hasil analisis ketika sudah selesai.
    public func analyze() async throws -> [String: Bool] {
        // Memulai proses dan menunggu hasilnya.
        return try await withCheckedThrowingContinuation { continuation in
            self.analysisContinuation = continuation
            startAudioAnalysis()
        }
    }

    private func startAudioAnalysis() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.record, mode: .measurement, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            self.analysisContinuation?.resume(throwing: error)
            return
        }
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        streamAnalyzer = SNAudioStreamAnalyzer(format: recordingFormat)

        do {
            let request = try SNClassifySoundRequest(mlModel: mlModel)
            try streamAnalyzer!.add(request, withObserver: self)
        } catch {
            self.analysisContinuation?.resume(throwing: error)
            return
        }

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.streamAnalyzer?.analyze(buffer, atAudioFramePosition: 0)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            self.analysisContinuation?.resume(throwing: error)
        }
    }

    private func stopAudioAnalysis() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        try? AVAudioSession.sharedInstance().setActive(false)
    }

    // MARK: - SNResultsObserving Delegate Methods

    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult else { return }

        guard let topClassification = result.classifications
            .filter({ $0.identifier != "background_noises" })
            .max(by: { $0.confidence < $1.confidence })
        else { return } // Hanya ada background noise, abaikan.

        let expectedWord = wordsToPractice[currentIndex]

        if topClassification.identifier == expectedWord && topClassification.confidence > 0.75 {
            print("Analyser correctly identified: \(expectedWord)")
            confidenceResults[expectedWord] = true
            
            // Pindah ke kata berikutnya
            if currentIndex < wordsToPractice.count - 1 {
                currentIndex += 1
            } else {
                // Semua kata sudah diucapkan dengan benar. Selesai!
                stopAudioAnalysis()
                analysisContinuation?.resume(returning: confidenceResults)
                analysisContinuation = nil // Hentikan continuation
            }
        }
    }

    func request(_ request: SNRequest, didFailWithError error: Error) {
        stopAudioAnalysis()
        analysisContinuation?.resume(throwing: error)
        analysisContinuation = nil
    }
}
