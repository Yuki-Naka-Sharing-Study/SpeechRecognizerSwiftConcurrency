//
//  TranscriberView.swift
//  SpeechRecognizerSwiftConcurrency
//
//  Created by 仲優樹 on 2025/06/28.
//

import SwiftUI

struct TranscriberView: View {
    @StateObject private var recorder = AudioRecorder()
    @StateObject private var recognizer = SpeechRecognizer()
    
    @State private var isRecording = false
    @State private var permissionGranted = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("ファイル文字起こし")
                .font(.title)
            
            ScrollView {
                Text(recognizer.transcript)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
            }
            .frame(height: 300)
            
            Button(action: {
                if isRecording {
                    recorder.stopRecording()
                    isRecording = false
                    
                    if let url = recorder.audioURL {
                        recognizer.transcribeAudioFile(at: url)
                    }
                } else {
                    recognizer.transcript = ""
                    recorder.startRecording()
                    isRecording = true
                }
            }) {
                Text(isRecording ? "停止して文字起こし" : "録音開始")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isRecording ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(!permissionGranted)
        }
        .padding()
        .onAppear {
            recognizer.requestAuthorization { granted in
                permissionGranted = granted
            }
        }
    }
}

#Preview {
    TranscriberView()
}
