//
//  LearningPage.swift
//  HakkaKing
//
//  Created by Amanda on 16/06/25.
//
import SwiftUI
import SwiftData
import AVFoundation

struct LearningPage: View {
    var chapter: Chapter
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var sentences: [Sentence] = []
    @State private var currentIndex = 0
    @State private var isRecording = false
    @StateObject private var recorder = RecordingController()
    @State private var audioPlayer: AVAudioPlayer?
    @State private var showExit = false
    
    // State BARU untuk hasil analisis ML
    @State private var analysisResult: [String: Bool]?
    @State private var analysisScore: Double?
    @State private var isAnalyzing = false
    
    // State BARU untuk navigasi ke halaman congrats
    @State private var showCongratsPage = false
    
    private var controller: ChapterController {
        ChapterController(context: context)
    }
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if showExit {
                ZStack{
                    VStack(spacing: 20) {
                        if !sentences.isEmpty && currentIndex < sentences.count  {
                            VStack{
                                VStack(spacing: 24){
                                    HStack(spacing: 8){
                                        ExitButton(showExitModal: $showExit)
                                        ProgressBar(progress: currentIndex + 1, total: 4)
                                    }
                                    
                                    PinyinComponent(sentence: sentences[currentIndex])
                                }
                                Spacer()
                                if recorder.isRecording || isAnalyzing {
                                    MicrophoneActiveComponent(isRecording: $isRecording, isAnalyzing: isAnalyzing)
                                        .padding(.bottom, 24)
                                } else if recorder.recordingURL == nil {
                                    MicrophoneInactiveComponent(isRecording: $isRecording, recordingController: recorder)
                                        .padding(.bottom, 24)
                                }
                            }
                            
                        } else {
                            // Tampilan saat chapter selesai atau loading
                            if sentences.isEmpty {
                                ProgressView("Loading...")
                            } else {
                                Text("Chapter Selesai!")
                            }
                        }
                    }.padding(.horizontal, 32)
                   
                    ExitModalView(isPresented: $showExit, onExit: {
                        dismiss()
                    })
                    .transition(.opacity)
                }
            }else{
                VStack(spacing: 20) {
                    if !sentences.isEmpty && currentIndex < sentences.count  {
                        VStack{
                            VStack(spacing: 24){
                                HStack(spacing: 8){
                                    ExitButton(showExitModal: $showExit)
                                    ProgressBar(progress: currentIndex + 1, total: 4)
                                }
                                
                                PinyinComponent(sentence: sentences[currentIndex])
                            }
                            Spacer()
                            if recorder.isRecording || isAnalyzing {
                                MicrophoneActiveComponent(isRecording: $isRecording, isAnalyzing: isAnalyzing)
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
            // Pop-up Evaluasi (hanya muncul setelah analisis selesai)
            if let result = analysisResult, let score = analysisScore {
                EvaluationComponent(
                    sentence: sentences[currentIndex],
                    score: score,
                    audioURL: recorder.recordingURL,
                    onLanjutkan: {
                        if currentIndex < sentences.count - 1 {
                            currentIndex += 1
                        } else {
                            // Kalimat terakhir selesai, tampilkan halaman congrats
                            showCongratsPage = true
                        }
                        resetStatesAfterEvaluation()
                    },
                    onUlangi: {
                        resetStatesAfterEvaluation()
                    }
                )
                .transition(.move(edge: .bottom))
            }
        }
        .onAppear {
            sentences = controller.fetchChapterSentences(for: chapter, context: context)
            recorder.recordingURL = nil
            recorder.setupAudioSession()
            if !sentences.isEmpty {
                playAudio(fileName: sentences[currentIndex].audioURL)
            }
        }
        .onChange(of: currentIndex) { newIndex in
            if newIndex < sentences.count {
                let audioFile = sentences[newIndex].audioURL
                playAudio(fileName: audioFile)
            }
        }
        
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BackgroundView())
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Menggunakan nama fungsi yang benar dari controller Anda
            sentences = controller.fetchChapterSentences(for: chapter, context: context)
            if !sentences.isEmpty {
                playAudio(fileName: sentences[currentIndex].audioURL)
            }
        }
        .onChange(of: currentIndex) {
            // Fungsionalitas auto-play Anda tetap ada
            if currentIndex < sentences.count {
                playAudio(fileName: sentences[currentIndex].audioURL)
            }
        }
        .onChange(of: recorder.recordingURL) { _, newURL in
            // Ini adalah "lem" yang menghubungkan rekaman dengan analisis AI
            if let url = newURL {
                Task {
                    isAnalyzing = true
                    let (result, error) = await controller.analyzePronunciation(fromAudioFile: url, for: sentences[currentIndex], in: chapter)
                    
                    if let resultData = result {
                        self.analysisResult = resultData
                        self.analysisScore = controller.evaluateScore(from: resultData)
                    } else {
                        print("Analysis task failed: \(error?.localizedDescription ?? "Unknown Error")")
                        self.analysisResult = [:] // Tampilkan hasil gagal jika ada error
                        self.analysisScore = 0
                    }
                    isAnalyzing = false
                }
            }
        }
        // Navigasi ke halaman Congrats setelah chapter selesai
        .navigationDestination(isPresented: $showCongratsPage) {
            CongratsView()
        }
        //        if let url = recorder.recordingURL, !showExit{
        //            EvaluationComponent(sentence: sentences[currentIndex],
        //                                audioURL: url) {
        //                if currentIndex < sentences.count - 1 {
        //                    currentIndex += 1
        //                    recorder.recordingURL = nil
        //                }
        //            }
        //                                .frame(height: UIScreen.main.bounds.height / 2)
        //                                .transition(.move(edge: .bottom))
        //        }
    }
    
    func resetStatesAfterEvaluation() {
        analysisResult = nil
        analysisScore = nil
        recorder.recordingURL = nil
    }
    
    private func playAudio(fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            print("Sentence audio not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            print("Played")
        } catch {
            print(
                "Failed to play sentence audio: \(error.localizedDescription)"
            )
        }
    }
}

