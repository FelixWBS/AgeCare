//
//  InsertController.swift
//  AgeCare
//
//  Created by Simon on 22.11.25.
//

import Foundation
import AVFoundation
import Speech
import Combine

@MainActor
final class TranscriptController: ObservableObject {
    // Published live transcript text
    @Published var currentText: String = ""

    // Optional hook to process a finished transcript later (e.g., API)
    var onDidFinishTranscript: ((Transcript) -> Void)?

    // Speech
    private let audioEngine = AVAudioEngine()
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    // MARK: - Init
    init(locale: Locale = Locale(identifier: Locale.preferredLanguages.first ?? "en-US")) {
        self.speechRecognizer = SFSpeechRecognizer(locale: locale)
    }

    // MARK: - Public API
    func startRecording() {
        // Request permissions if needed
        Task { @MainActor [weak self] in
                guard let self else { return }
                let authGranted = await Self.requestSpeechAuthorization()
                let micGranted = await Self.requestMicrophonePermission()
                guard authGranted && micGranted else {
                    print("❌ Permissions not granted")
                    return
                }
                await self.configureAndStartRecognition()
            }
    }

    func stopRecording() {
        if audioEngine.isRunning {
                audioEngine.stop()
                audioEngine.inputNode.removeTap(onBus: 0)
            }
            
            recognitionRequest?.endAudio()
            recognitionTask?.cancel()
            recognitionTask = nil
            recognitionRequest = nil
            
            // Kurze Verzögerung, damit Audio I/O wirklich beendet ist
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 Sekunden
                
                do {
                    try AVAudioSession.sharedInstance().setActive(false,
                        options: .notifyOthersOnDeactivation)
                } catch {
                    print("❌ Error deactivating audio session: \(error)")
                }
                
                let transcript = Transcript(text: currentText)
                print(currentText)
                onDidFinishTranscript?(transcript)
            }
    }

    // MARK: - Private helpers
    private func configureAndStartRecognition() {
        recognitionTask?.cancel()
        recognitionTask = nil
        currentText = ""

        let audioSession = AVAudioSession.sharedInstance()
        do {
            // Bessere Konfiguration für Speech Recognition
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("❌ AudioSession error: \(error)")
            return
        }
    

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        do { try audioEngine.start() } catch {
            print("❌ AudioEngine start error: \(error)")
            return
        }

        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            print("❌ Speech recognizer not available")
            return
        }

        recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self else { return }
            if let result {
                // Update live text on main actor
                Task { @MainActor in
                    self.currentText = result.bestTranscription.formattedString
                }
            }
            if error != nil || (result?.isFinal == true) {
                // Stop the engine automatically if final
                self.audioEngine.stop()
                self.audioEngine.inputNode.removeTap(onBus: 0)
            }
        }
    }

    // MARK: - Permissions
    private static func requestSpeechAuthorization() async -> Bool {
        await withCheckedContinuation { cont in
            SFSpeechRecognizer.requestAuthorization { status in
                cont.resume(returning: status == .authorized)
            }
        }
    }

    private static func requestMicrophonePermission() async -> Bool {
        await withCheckedContinuation { cont in
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                cont.resume(returning: granted)
            }
        }
    }
}
