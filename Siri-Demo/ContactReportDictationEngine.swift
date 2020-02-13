//
//  DictateContactReport.swift
//  Siri-Demo
//
//  Created by Christi Schneider on 1/21/20.
//  Copyright © 2020 Blackbaud. All rights reserved.
//

import Foundation
import Speech
import AVFoundation
import SkyUX
import SkyApiCore
import Intents
import UIKit

class ContactReportDictationEngine: NSObject {
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer()
    var speechRecognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let avSpeechSynthesizer = AVSpeechSynthesizer()
    var statusLabel: SkyLabel!
    var resultLabel: SkyLabel!
    var lastTimeTriggered: Date?
    var lastSearchResult: ConstituentSearchResult?
    var searchText: String?
    var finalCompletion: (() -> Void)?

    init(statusLabel: SkyLabel, resultLabel: SkyLabel) {
        self.statusLabel = statusLabel
        self.resultLabel = resultLabel
    }

    public func stop() {
        print("Contact report dictation engine - stop")
        
        // Stop speaking
        avSpeechSynthesizer.stopSpeaking(at: .immediate)
        
        // Stop recording
        audioEngine.stop()
        speechRecognitionRequest?.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionTask?.cancel()
        
        // Reset labels
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.statusLabel.text = ""
            self.resultLabel.text = ""
        }
    }

    public func startDictation(completion: @escaping () -> Void) {
        
        print("startDictation")

        // TODO Ideal workflow:
        // Could ask for other fields too like additional fundraisers, outcome, location, etc.
        // 1. Ask which constituent
        // 2. Use search to determine the correct constituent, and confirm
        // 3. Check if there are any incomplete actions for today or past due. If yes:
        //    Ask if the action they are filing a contact report is the action that was found. If yes:
        //      Go to step 6
        // 4. Ask what category - options are Phone Call, Meeting, Mailing, Email, and Task/Other
        // 5. Ask for the summary (maybe we can compute this for them. i.e. "Phone Call with Robert")
        // 6. Tell the user to begin dictating
        // 7. When pause, ask if they're done
        // 8. When done, add/update the action on the constituent record
        // 9. Donate the action
        // 10. Tell the user how to add a shortcut to do the same thing next time

        // Implemented workflow:
        // 1. Ask which constituent
        // 2. Use search to determine the best matching constituent
        // 3. Tell the user to begin dictating
        // 4. Add the action to the constituent record with category "Meeting" and summary "Contact Report Dictated from iPhone"
        // 5. Donate the action
        // 6. Tell the user how to add a shortcut to do the same thing next time

        self.finalCompletion = completion
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.statusLabel.text = "Starting contact report"
        }

        avSpeechSynthesizer.delegate = self
        let utterance = AVSpeechUtterance(string: "What is the name of the constituent?")
        avSpeechSynthesizer.speak(utterance)
        // Continues with continueAfterAskingForName

    }

    private func continueAfterAskingForName() {

        print("continueAfterAskingForName")

        speechRecognizer?.defaultTaskHint = SFSpeechRecognitionTaskHint.search
        transcribeAudio(completion: { (recording) in

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.statusLabel.text = "Searching for \(recording)"
            }

            SkyApiAuthentication.retrieveAccessToken(groupName: "group.com.blackbaud.bbshortcuts1", completionHandler: { (accessToken) in
                guard let accessToken = accessToken else {
                    print("Error: No SKY API access token")
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.statusLabel.text = "Error: No access token"
                    }
                    return
                }

                let api = ConstituentApi()
                api.findConstituent(accessToken: accessToken, searchText: recording, completion: { searchResult, error in
                    if let error = error {
                        print("Error finding constituent \(error)")
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.statusLabel.text = "Error finding constituent \(error)"
                        }
                    }

                    guard let searchResult = searchResult else {
                        print("No constituent found")
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.statusLabel.text = "No constituent found"
                        }
                        return
                    }

                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.statusLabel.text = "Found constituent"
                        self.resultLabel.text = searchResult.name
                    }


                    // Donate an intent to find a constituent so the suggestion shows in Shortcuts
                    print("Donating interaction to find a constituent")
                    let intent = ConstituentInfoIntent()
                    intent.suggestedInvocationPhrase = "Find a constituent"
                    intent.searchText = recording

                    let interaction = INInteraction(intent: intent, response: nil)
                    interaction.donate { (error) in
                        if error != nil {
                            if let error = error as NSError? {
                                print("Interaction donation failed: \(error.description)")
                            } else {
                                print("Interaction donation failed")
                            }
                        } else {
                           print("Successfully donated interaction")
                       }
                    }

                    self.lastSearchResult = searchResult
                    self.searchText = recording

                    let utterance = AVSpeechUtterance(string: "You may start dictating.")
                    self.avSpeechSynthesizer.speak(utterance)
                    // Continues with dictateContactReportContinueAfterStartDictating
                })
            })
        })

    }

    private func continueAfterStartDictating() {

        print("continueAfterStartDictating")

        guard let constituent = lastSearchResult else {
            return
        }

        self.speechRecognizer?.defaultTaskHint = SFSpeechRecognitionTaskHint.dictation
        transcribeAudio(completion: { (recording) in

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.statusLabel.text = "Saving contact report"
                self.resultLabel.text = recording
            }


            SkyApiAuthentication.retrieveAccessToken(groupName: "group.com.blackbaud.bbshortcuts1", completionHandler: { (accessToken) in
                guard let accessToken = accessToken else {
                    // TODO error handling
                    return
                }

                let api = ConstituentApi()
                api.createAction(accessToken: accessToken, constituentId: constituent.id, category: "Meeting", summary: "Contact Report Dictated from iPhone", description: recording, date: Date(), completion: { (error) in

                    if let error = error {
                        print("Error creating action \(error)")
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.statusLabel.text = "Error saving report"
                            if let httpError = error as? HttpError {
                                var result = "Http status: \(httpError.statusCode)."
                                if let dataAsString = httpError.dataAsString {
                                    result = "\(result) \(dataAsString)"
                                }
                                self.resultLabel.text = result
                            }
                        }
                        return
                    }

                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.statusLabel.text = "Contact report saved"
                        self.resultLabel.text = ""
                    }

                    // Donate the interaction so Shortcuts app has suggestions
                    print("Donating interaction for filing a contact report")
                    let intent = FileContactReportIntent()
                    intent.suggestedInvocationPhrase = "File a contact report for \(self.searchText ?? "")"
                    intent.lookupId = constituent.lookup_id
                    intent.text = recording
                    let interaction = INInteraction(intent: intent, response: nil)
                    interaction.donate { (error) in
                        if error != nil {
                            if let error = error as NSError? {
                                print("Interaction donation failed: \(error.description)")
                            } else {
                                print("Interaction donation failed")
                            }
                        } else {
                           print("Successfully donated interaction")
                       }
                    }

                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.resultLabel.text = "You can add a shortcut to dictate another contact report in the Shortcuts app"
                    }
                    
                    if let finalCompletion = self.finalCompletion {
                        finalCompletion()
                    }

                })
            })

        })
    }

    private func transcribeAudio(completion: @escaping (String) -> Void) {

        print("transcribeAudio")

        SFSpeechRecognizer.requestAuthorization {
            [unowned self] (authStatus) in
            switch authStatus {
            case .authorized:
                
                switch AVAudioSession.sharedInstance().recordPermission {
                case AVAudioSessionRecordPermission.granted:
                    print("Record permission granted")

                    do {
                        try self.startRecording(completion: completion)
                    } catch let error {
                        print("There was a problem starting recording: \(error.localizedDescription)")
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.statusLabel.text = "Error starting recording"
                            self.resultLabel.text = ""
                        }
                    }
                    return
                case AVAudioSessionRecordPermission.denied:
                    print("Record pemission denied")
                case AVAudioSessionRecordPermission.undetermined:
                    print("Record permission not given - requesting")
                    AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                        // Handle granted
                        if (granted) {
                            do {
                                try self.startRecording(completion: completion)
                            } catch let error {
                                print("There was a problem starting recording: \(error.localizedDescription)")
                                DispatchQueue.main.async { [weak self] in
                                    guard let self = self else { return }
                                    self.statusLabel.text = "Error starting recording"
                                    self.resultLabel.text = ""
                                }
                            }
                        } else {
                            DispatchQueue.main.async { [weak self] in
                                guard let self = self else { return }
                                self.statusLabel.text = "Microphone is not available"
                                self.resultLabel.text = ""
                            }
                        }
                    })
                    return
                @unknown default:
                    break
                }

                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.statusLabel.text = "Microphone is not available"
                    self.resultLabel.text = ""
                }
                return

            case .denied:
                print("Speech recognition authorization denied")
            case .restricted:
                print("Not available on this device")
            case .notDetermined:
                print("Not determined")
            default:
                print("Unknown")
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.statusLabel.text = "Speech recognition is not available"
                self.resultLabel.text = ""
            }

        }

    }

    private func startRecording(completion: @escaping (String) -> Void) throws {

        print("startRecording")

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.statusLabel.text = "Recording"
        }

        self.speechRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        // 1
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)

        // 2
        node.installTap(onBus: 0, bufferSize: 1024,
                        format: recordingFormat) { [unowned self]
                            (buffer, _) in
                            self.speechRecognitionRequest?.append(buffer)
        }

        // 3
        audioEngine.prepare()
        try audioEngine.start()

        recognitionTask = speechRecognizer?.recognitionTask(with: speechRecognitionRequest!) {
            [unowned self]
            (result, _) in

            if let transcription = result?.bestTranscription {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.resultLabel.text = transcription.formattedString
                }
                let currentDate = Date()
                self.lastTimeTriggered = currentDate
                let args = stopRecordingAfterPauseArgs(timeTriggered: currentDate, recording: transcription.formattedString, completion: completion)
                self.perform(#selector(self.stopRecordingAfterPause), with: args, afterDelay: 1.5)
            }
        }

    }

    @objc
    class stopRecordingAfterPauseArgs: NSObject {
        init(timeTriggered: Date, recording: String, completion: @escaping (String) -> Void) {
            self.timeTriggered = timeTriggered
            self.recording = recording
            self.completion = completion
        }
        var timeTriggered: Date
        var recording: String
        var completion: (String) -> Void
    }

    @objc
    private func stopRecordingAfterPause(args: stopRecordingAfterPauseArgs) {
        guard let lastTimeTriggered = lastTimeTriggered else {
            return
        }
        guard lastTimeTriggered == args.timeTriggered else {
            return
        }
        print("stopRecordingAfterPause")
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.statusLabel.text = "Not recording"
        }
        audioEngine.stop()
        speechRecognitionRequest?.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionTask?.cancel()
        args.completion(args.recording)
    }

}

extension ContactReportDictationEngine: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("speechSynthesizer didStart")
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("speechSynthesizer didFinish")
        switch utterance.speechString {
        case "What is the name of the constituent?":
            continueAfterAskingForName()
            break
        case "You may start dictating.":
            continueAfterStartDictating()
            break
        default:
            print("Unknown utterance completed: \(utterance.speechString)")
        }
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        print("speechSynthesizer didPause")
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        print("speechSynthesizer didContinue")
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        print("speechSynthesizer didCancel")
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        print("speechSynthesizer willSpeakRangeOfSpeechString")
    }
}
