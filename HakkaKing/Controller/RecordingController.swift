//
//  RecordingController.swift
//  HakkaKing
//
//  Created by Amanda on 16/06/25.
//


import Foundation
import AVFoundation

class RecordingController: ObservableObject {
    @Published var isRecording = false
    @Published var recordingURL: URL?

    private var audioRecorder: AVAudioRecorder?

    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true)
        } catch {
            print("Failed to setup audio session: \(error.localizedDescription)")
            return
        }

        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documents.appendingPathComponent("recorded_audio.m4a")
//        self.recordingURL = fileURL

        let settings: [String : Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            isRecording = true
            print("Recording started at \(fileURL).")

            // Stop after 7 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.stopRecording()
            }
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        recordingURL = audioRecorder?.url
        isRecording = false
        print("Recording stopped.")
    }

    func requestPermissionAndRecord() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                if granted {
                    self.startRecording()
                } else {
                    print("Microphone permission denied.")
                }
            }
        }
    }
    
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            print("Audio session configured for playback")
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
    }
}
