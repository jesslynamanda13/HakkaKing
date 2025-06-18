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
    @State private var currentWords: [Word] = [] // <- Menyimpan daftar kata untuk kalimat saat ini
    @State private var currentIndex = 0
    @State private var isRecording = false
    @StateObject private var recorder = RecordingController()
    @State private var audioPlayer: AVAudioPlayer?
    @State private var showExit = false
    
    // State BARU untuk hasil analisis ML
    @State private var analysisResult: [String: Bool]?
    @State private var analysisScore: Double?
    @State private var isAnalyzing = false
    
    
    // State untuk melacak percobaan & navigasi
    @State private var attemptCount = 0
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
                                MicrophoneActiveComponent(isRecording: .constant(recorder.isRecording), isAnalyzing: isAnalyzing)
                                    .padding(.bottom, 24)
                            } else if recorder.recordingURL == nil {
                                MicrophoneInactiveComponent(isRecording: .constant(recorder.isRecording), recordingController: recorder)
                                    .padding(.bottom, 24)
                            }
                        }
                        
                    } else {
                        ProgressView()
                    }
                }
                .padding(.horizontal, 32)
                .zIndex(0)
            }
            // Pop-up Evaluasi (hanya muncul setelah analisis selesai)
            
            // MARK: Evaluation Pop-up
            if let score = analysisScore, let result = analysisResult {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(1)

                EvaluationComponent(
                    sentence: sentences[currentIndex],
                    wordsInSentence: currentWords, // <- Kirim data [Word]
                    score: score,
                    attemptCount: self.attemptCount,
                    audioURL: recorder.recordingURL,
                    analysisResult: result,
                    onLanjutkan: {
                        if currentIndex < sentences.count - 1 {
                            currentIndex += 1
                        } else {
                            showCongratsPage = true
                        }
                        resetForNewSentence()
                    },
                    onCobaLagi: {
                        resetForNewAttempt()
                        recorder.requestPermissionAndRecord()
                    }
                )
                .zIndex(2)
                .transition(.move(edge: .bottom).combined(with: .opacity))
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
        .animation(.spring(), value: analysisScore != nil)
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
            updateCurrentSentenceData()
        }
        .onChange(of: currentIndex) {
            // Fungsionalitas auto-play Anda tetap ada
            if currentIndex < sentences.count {
                playAudio(fileName: sentences[currentIndex].audioURL)
            }
            updateCurrentSentenceData()
        }
        .onChange(of: recorder.recordingURL) { _, newURL in
            if let url = newURL {
                Task {
                    self.attemptCount += 1
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
//        .onChange(of: recorder.recordingURL) { _, newURL in
//            // Ini adalah "lem" yang menghubungkan rekaman dengan analisis AI
//            if let url = newURL {
//                Task {
//                    isAnalyzing = true
//                    let (result, error) = await controller.analyzePronunciation(fromAudioFile: url, for: sentences[currentIndex], in: chapter)
//                    
//                    if let resultData = result {
//                        self.analysisResult = resultData
//                        self.analysisScore = controller.evaluateScore(from: resultData)
//                    } else {
//                        print("Analysis task failed: \(error?.localizedDescription ?? "Unknown Error")")
//                        self.analysisResult = [:] // Tampilkan hasil gagal jika ada error
//                        self.analysisScore = 0
//                    }
//                    isAnalyzing = false
//                }
//            }
//        }
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
    
    // Fungsi baru untuk mengambil data kata dan memutar audio
    private func updateCurrentSentenceData() {
        guard currentIndex < sentences.count else { return }
        let currentSentence = sentences[currentIndex]
        self.currentWords = controller.fetchWords(for: currentSentence) // <- Mengambil data kata
        playAudio(fileName: currentSentence.audioURL)
    }
    
    func resetForNewAttempt() {
        analysisResult = nil
        analysisScore = nil
        recorder.recordingURL = nil
    }
    
    func resetForNewSentence() {
        resetForNewAttempt()
        attemptCount = 0
    }
    
    private func playAudio(fileName: String) {
        guard !fileName.isEmpty,
              let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            print("Audio file not found or name is empty for sentence")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Failed to play audio: \(error.localizedDescription)")
        }
    }
}

