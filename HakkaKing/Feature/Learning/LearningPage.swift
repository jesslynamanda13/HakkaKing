import SwiftUI
import SwiftData
import AVFoundation

struct LearningPage: View {
    var chapter: Chapter
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    // State asli Anda, tidak diubah
    @State private var sentences: [Sentence] = []
    @State private var currentIndex = 0
    @State private var isRecording = false
    @StateObject private var recorder = RecordingController()
    @State private var audioPlayer: AVAudioPlayer?
    
    // State BARU untuk menampung hasil AI
    @State private var analysisResult: [String: Bool]?
    @State private var analysisScore: Double?
    @State private var isAnalyzing = false
    
    private var controller: ChapterController {
        ChapterController(context: context)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 20) {
                if !sentences.isEmpty && currentIndex < sentences.count {
                    VStack {
                        VStack(spacing: 24) {
                            HStack(spacing: 8) {
                                ExitButton()
                                ProgressBar(progress: currentIndex + 1, total: sentences.count)
                            }
                            PinyinComponent(sentence: sentences[currentIndex])
                        }
                        Spacer()
                        
                        // Logika tombol Anda, dengan tambahan status isAnalyzing
                        if recorder.isRecording || isAnalyzing {
                            MicrophoneActiveComponent(isRecording: $isRecording, isAnalyzing: isAnalyzing) // Pass isAnalyzing
                                .padding(.bottom, 24)
                        } else if recorder.recordingURL == nil {
                            MicrophoneInactiveComponent(isRecording: $isRecording, recordingController: recorder)
                                .padding(.bottom, 24)
                        }
                    }
                } else {
                    Text("All done.")
                }
            }.padding(.horizontal, 32)
        }
        .onAppear {
            let controller = ChapterController(context: context)
            // Menggunakan nama fungsi yang benar
            sentences = controller.fetchChapterSentences(for: chapter, context: context)
            recorder.recordingURL = nil
            recorder.setupAudioSession()
            // Logika auto-play Anda tetap ada
            if let firstSentence = sentences.first {
                playAudio(fileName: firstSentence.audioURL)
            }
        }
        .onChange(of: currentIndex) {
             // Logika auto-play Anda tetap ada
            if currentIndex < sentences.count {
                playAudio(fileName: sentences[currentIndex].audioURL)
            }
        }
        // TAMBAHAN: Ini adalah pemicu untuk analisis AI
        .onChange(of: recorder.recordingURL) { _, newURL in
            if let url = newURL {
                Task {
                    isAnalyzing = true
                    let (result, error) = await controller.analyzePronunciation(fromAudioFile: url, for: sentences[currentIndex], in: chapter)
                    
                    if let resultData = result {
                        self.analysisResult = resultData
                        self.analysisScore = controller.evaluateScore(from: resultData)
                    } else {
                        print("Analysis task failed: \(error?.localizedDescription ?? "Unknown error")")
                        self.analysisResult = [:]
                        self.analysisScore = 0
                    }
                    isAnalyzing = false
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BackgroundView())
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        
        // Logika pop-up evaluasi yang sekarang menggunakan hasil AI
        if let result = analysisResult, let score = analysisScore {
            EvaluationComponent(
                sentence: sentences[currentIndex],
                score: score,
                audioURL: recorder.recordingURL,
                onLanjutkan: {
                    if currentIndex < sentences.count - 1 {
                        currentIndex += 1
                    } else {
                        dismiss()
                    }
                    resetStates()
                },
                onUlangi: {
                    resetStates()
                }
            )
            .transition(.move(edge: .bottom))
        }
    }
    
    func resetStates() {
        recorder.recordingURL = nil
        analysisResult = nil
        analysisScore = nil
    }
    
    private func playAudio(fileName: String?) {
        guard let fileName = fileName, let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            print("Sentence audio not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Failed to play sentence audio: \(error.localizedDescription)")
        }
    }
}

