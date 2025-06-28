//
//  AudioRecorder.swift
//  SpeechRecognizerSwiftConcurrency
//
//  Created by 仲優樹 on 2025/06/28.
//

import Foundation
import AVFoundation

class AudioRecorder: ObservableObject {
    private var recorder: AVAudioRecorder?
    @Published var audioURL: URL?
    
    func startRecording() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playAndRecord, mode: .default, options: [])
        try? session.setActive(true)
        
        let fileName = UUID().uuidString + ".m4a"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        recorder = try? AVAudioRecorder(url: url, settings: settings)
        recorder?.record()
        audioURL = url
    }
    
    func stopRecording() {
        recorder?.stop()
    }
}
