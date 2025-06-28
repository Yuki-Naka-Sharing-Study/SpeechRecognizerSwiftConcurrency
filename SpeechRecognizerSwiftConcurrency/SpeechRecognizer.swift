//
//  SpeechRecognizer.swift
//  SpeechRecognizerSwiftConcurrency
//
//  Created by 仲優樹 on 2025/06/28.
//

import Foundation
import Speech

@MainActor
class SpeechRecognizer: ObservableObject {
    @Published var transcript: String = ""
    
    func transcribeAudioFile(at url: URL) {
        Task.detached { [weak self] in
            let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))
            let request = SFSpeechURLRecognitionRequest(url: url)
            
            guard let self else { return }
            
            try? await withCheckedContinuation { continuation in
                recognizer?.recognitionTask(with: request) { result, error in
                    if let result = result {
                        Task { @MainActor in
                            self.transcript = result.bestTranscription.formattedString
                        }
                    }
                    
                    if result?.isFinal == true || error != nil {
                        continuation.resume()
                    }
                }
            }
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                completion(status == .authorized)
            }
        }
    }
}
