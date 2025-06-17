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
    
    @State private var sentences: [Sentence] = []
    @State private var currentIndex = 0
    
    @State private var isRecording = false
    @StateObject private var recorder = RecordingController()
    
    @State private var audioPlayer: AVAudioPlayer?
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 20) {
                if !sentences.isEmpty && currentIndex < sentences.count  {
                    VStack{
                        VStack(spacing: 24){
                            HStack(spacing: 8){
                                ExitButton()
                                ProgressBar(progress: currentIndex + 1, total: 4)
                            }
                            
                            PinyinComponent(sentence: sentences[currentIndex])
                        }
                        Spacer()
                        if recorder.isRecording  {
                            MicrophoneActiveComponent(isRecording: $isRecording).padding(.bottom, 24)
                        }else if recorder.recordingURL == nil{
                            MicrophoneInactiveComponent(isRecording: $isRecording, recordingController: recorder).padding(.bottom, 24)
                        }
                    }
                    
                } else {
                    Text("All done.")
                }
            }.padding(.horizontal, 32)
            
        }
        .onAppear {
            let controller = ChapterController(context: context)
            sentences = controller.fetchSentences(for: chapter, context: context)
            recorder.recordingURL = nil
            recorder.setupAudioSession()
            playAudio(fileName: sentences[currentIndex].audioURL)
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
        if let url = recorder.recordingURL {
            EvaluationComponent(sentence: sentences[currentIndex],
                                 audioURL: url) {
                // Callback when "Lanjutkan" is pressed
                if currentIndex < sentences.count - 1 {
                    currentIndex += 1
                    recorder.recordingURL = nil
                }
            }
            .frame(height: UIScreen.main.bounds.height / 2)
            .transition(.move(edge: .bottom))
        }
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

