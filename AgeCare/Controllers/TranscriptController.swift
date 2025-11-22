//
//  TranscriptController.swift
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
    // Live transcript text
    @Published var currentText: String = ""

    // Recording state and error for UI
    @Published var state: RecordingState = .idle
    @Published var errorMessage: String?

    // Optional hook to process a finished transcript later (e.g., API)
    var onDidFinishTranscript: ((Transcript) -> Void)?

    // MARK: - Private properties
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var speechRecognizer: SFSpeechRecognizer?

    private var finalizedTranscript: String = ""
    private var volatileTranscript: String = ""

    private let locale: Locale
    
    private let app_con: AppointmentController

    /// Set true to prefer on-device recognition when available (iOS 13+ and supported locale)
    var preferOnDeviceRecognition: Bool = false

    // MARK: - Init
    init(locale: Locale = Locale(identifier: Locale.preferredLanguages.first ?? "en-US"), appointmentController: AppointmentController) {
        self.locale = locale
        self.speechRecognizer = Self.makeRecognizer(for: locale)
        self.app_con = appointmentController
    }

    // MARK: - Public API

    func startRecording() {
        print("Start recording called")
        Task { @MainActor [weak self] in
            guard let self else { return }

            state = .requestingPermissions
            errorMessage = nil

            // Ensure recognizer exists for the configured locale (fallback to en-US if not supported)
            if self.speechRecognizer == nil {
                self.speechRecognizer = Self.makeRecognizer(for: self.locale)
            }

            #if targetEnvironment(simulator)
            print("ℹ️ Running in Simulator: Speech recognition may be unavailable or unreliable. Prefer testing on a physical device.")
            #endif

            // Request permissions for mic and speech recognition
            let micGranted = await Self.requestMicrophonePermission()
            let speechGranted = await Self.requestSpeechAuthorization()
            guard micGranted && speechGranted else {
                let msg = "Permissions not granted (mic: \(micGranted), speech: \(speechGranted))."
                print("❌ \(msg)")
                self.errorMessage = msg
                self.state = .error
                return
            }

            do {
                try setUpAudioSession()
                try startRecognition()
                state = .recording
            } catch {
                let msg = "Failed to start recording: \(error)"
                print("❌ \(msg)")
                errorMessage = msg
                state = .error
                stopRecording()
            }
        }
    }

    func stopRecording() {
        print("Stop recording called")
        Task { @MainActor [weak self] in
            guard let self else { return }

            state = .stopping

            if audioEngine.isRunning {
                audioEngine.stop()
                audioEngine.inputNode.removeTap(onBus: 0)
            }

            recognitionRequest?.endAudio()
            recognitionRequest = nil
            recognitionTask = nil

            // Deactivate audio session
            do {
                try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
            } catch {
                print("❌ Error deactivating audio session: \(error)")
            }

            // Compose final transcript: prefer finalized, fallback to current volatile text
            let text = finalizedTranscript.isEmpty ? currentText : finalizedTranscript
            let transcript = Transcript(text: text)
            onDidFinishTranscript?(transcript)

            state = .idle
            
            
            // API CALL
            Task {
                await callServer(message: text, appointmentController: self.app_con)
            }
            
            print(text)
        }
        
    }

    // MARK: - Private helpers

    /// Sets up AVAudioSession for recording (iOS)
    private func setUpAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        // Use recording category + measurement mode for speech input
        try session.setCategory(.record, mode: .measurement, options: [.duckOthers])
        try session.setActive(true, options: .notifyOthersOnDeactivation)
    }

    /// Starts a streaming speech recognition task using SFSpeechRecognizer
    private func startRecognition() throws {
        guard let recognizer = speechRecognizer else {
            throw TranscriptionError.recognizerUnavailable
        }
        guard recognizer.isAvailable else {
            throw TranscriptionError.recognizerUnavailable
        }

        // Reset state
        finalizedTranscript = ""
        volatileTranscript = ""
        currentText = ""

        // Ensure any previous task is cleaned up
        recognitionTask?.cancel()
        recognitionTask = nil

        // Create a new request for streaming audio
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        if preferOnDeviceRecognition {
            if #available(iOS 13.0, *), recognizer.supportsOnDeviceRecognition {
                request.requiresOnDeviceRecognition = true
            } else {
                print("ℹ️ On-device recognition not supported; falling back to server-based recognition.")
            }
        }
        self.recognitionRequest = request

        // Install tap on the input node to stream audio to the request
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 4096, format: recordingFormat) { [weak self] buffer, _ in
            guard let self = self else { return }
            self.writeBufferToDisk(buffer)
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()

        // Start recognition task
        recognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
            guard let self = self else { return }

            if let result = result {
                self.volatileTranscript = result.bestTranscription.formattedString
                Task { @MainActor in
                    self.currentText = self.volatileTranscript
                }

                if result.isFinal {
                    self.finalizedTranscript += result.bestTranscription.formattedString + " "
                }
            }

            if let error = error {
                let msg = "Recognition error: \(error)"
                print("❌ \(msg)")
                Task { @MainActor in
                    self.errorMessage = msg
                    self.state = .error
                }
                self.audioEngine.stop()
                self.recognitionRequest?.endAudio()
            }
        }
    }

    

    private static func makeRecognizer(for locale: Locale) -> SFSpeechRecognizer? {
        let supported = SFSpeechRecognizer.supportedLocales()
        if supported.contains(where: { $0.identifier == locale.identifier }) {
            return SFSpeechRecognizer(locale: locale)
        } else {
            // Fallback to en-US if requested locale isn't supported on this device
            return SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        }
    }

    /// Dummy stub to write audio buffer to disk (does nothing here)
    private func writeBufferToDisk(_ buffer: AVAudioPCMBuffer) {
        // Stub: no action needed for now
    }

    // MARK: - Permissions helpers

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

    // MARK: - TranscriptionError enum

    enum TranscriptionError: Error {
        case failedToSetupRecognitionStream
        case recognizerUnavailable
    }

    enum RecordingState: Equatable {
        case idle
        case requestingPermissions
        case ready
        case recording
        case stopping
        case error
    }
}

