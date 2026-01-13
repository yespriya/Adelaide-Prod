//
//  EducationalChatViewController.swift
//  HelloAlfred
//
//  Created by admin on 03/07/24.
//

import UIKit
import IQKeyboardManagerSwift
import Foundation
import Speech
import AVFoundation

class EducationalChatViewController: BaseViewController,KeyboardHandling, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var inputMessageTextView: InputTextView!
    @IBOutlet var textViewHeight: NSLayoutConstraint!
    @IBOutlet var recordButton: UIButton!
    
    var completionHandler: ((String) -> Void)?
    var msg = ""
    var viewModel = ChatViewModel()
    var messages: [Message] = []
    var sessionID : String?
    var dataLoading = false
    var tempVoiceText = ""
    var eduChatViewModel = EducationChatViewModel()
    
    // MARK: - Speech Properties
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US")) // Use the locale identifier for your language
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    let speechSynthesizer = AVSpeechSynthesizer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupKeyboardObservers()
        sessionID = generateUUIDv8()
        inputMessageTextView.placeholder = "Enter your message"
        textViewHeight.isActive = false
        setupInitialState()
        fetchInitialData()
        // recordButton.isEnabled = false
        speechRecognizer?.delegate = self
        // Request authorization
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.recordButton.isEnabled = true
                case .denied, .restricted, .notDetermined:
                    self.recordButton.isEnabled = false
                @unknown default:
                    self.recordButton.isEnabled = false
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Disable IQKeyboardManager for this view controller
        IQKeyboardManager.shared.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.isEnabled = true
        removeKeyboardObservers()
    }
    
    // MARK: - Setup Methods
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "MessageTableViewCell", bundle: .main), forCellReuseIdentifier: "MessageTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        //  inputMessageTextView.delegate = self
    }
    
    private func fetchInitialData() {
         self.activityIndicator(self.view, startAnimate: true)
        guard !eduChatViewModel.isLoading else { return }
        fetchStaticMessage()
    }
    private func fetchStaticMessage() {
        eduChatViewModel.fetchStaticMessage()
        eduChatViewModel.getStaticMessageResSuccess = { [weak self] in
            guard let self = self else { return }
            self.activityIndicator(view.self, startAnimate: false)
            initializeChat(welcomeMessage: eduChatViewModel.staticMessageRes?.data?.welcome_message ?? "Hello, I am Alfred! How can i Assist you today?")
        }
        eduChatViewModel.errorMessageAlert = {
            self.showAlert(self.eduChatViewModel.errorMessage ?? "Error")
        }
    }
    // MARK: - Actions
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        sendText()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - Keyboard Handling
    
    func adjustForKeyboard(notification: NSNotification, show: Bool) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        bottomConstraint.constant = show ? keyboardFrame.height + 20 : 20
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        scrollToLast()
    }
    func sendText()
    {
        guard let text = inputMessageTextView.text, !text.isEmpty else {
            showAlert("Please enter a text")
            return
        }
        appendMessage(text, isSender: true)
        // updateMessageApiCall(text: text)
        
        inputMessageTextView.isEditable = false
        appendMessage("LOADING", isSender: false,loading: true)
        self.dataLoading = true
        tableView.reloadData()
        scrollToLast()
        sendPostRequest(message: text) { response in
            if(self.messages[self.messages.count - 1].text == "LOADING")
            {
                self.messages.removeLast()
            }
            if(self.messages[self.messages.count - 1].isSender == true)
            {
                self.appendMessage(response, isSender: false)
            }
            else
            {
                self.updateLastMessage(with: response)
            }
        }
        inputMessageTextView.text = ""
    }
    
    func speakText(textToSpeak:String)
    {
        // Create an utterance object with the text
        let speechUtterance = AVSpeechUtterance(string: textToSpeak)
        
        // Set the language for the speech (e.g., US English)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        // Optional: Adjust the speaking rate (between 0.0 and 1.0)
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        
        // Make the synthesizer speak the utterance
        speechSynthesizer.speak(speechUtterance)
    }
    
    func shareText(text:String)
    {
        // Initialize the UIActivityViewController with the text
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        // Exclude some activity types if you don't want them in the sharing options
        activityViewController.excludedActivityTypes = [.print, .assignToContact, .saveToCameraRoll]
        // Present the activity view controller
        present(activityViewController, animated: true, completion: nil)
    }
    func generateUUIDv8() -> String? {
        // Generate 16 random bytes
        var bytes = [UInt8](repeating: 0, count: 16)
        _ = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        
        // Set version to 8 (Custom version)
        bytes[6] = (bytes[6] & 0x0F) | 0x80
        
        // Set variant to RFC 4122 (the most significant bits to 0b10)
        bytes[8] = (bytes[8] & 0x3F) | 0x80
        
        // Convert the bytes array to a uuid_t (tuple of 16 UInt8s)
        let uuidBytes: uuid_t = (
            bytes[0], bytes[1], bytes[2], bytes[3],
            bytes[4], bytes[5], bytes[6], bytes[7],
            bytes[8], bytes[9], bytes[10], bytes[11],
            bytes[12], bytes[13], bytes[14], bytes[15]
        )
        
        // Create the UUID from the uuid_t tuple
        let uuid = UUID(uuid: uuidBytes)
        
        return uuid.uuidString
    }
    
    func scrollToLast() {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if lastRowIndex >= 0 {
            let indexPath = IndexPath(row: lastRowIndex, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    func removeElements(from index: Int) {
        DispatchQueue.main.async {
            print("index \(index)")
            guard index < self.messages.count else { return }
            
            let numberOfElementsToRemove = self.messages.count - index
            self.messages.removeLast(numberOfElementsToRemove)
            
            self.tableView.reloadData()
            // self.scrollToLast() // Uncomment if needed
        }
    }
    
    
    
    
    private func initializeChat(welcomeMessage: String) {
        appendMessage(welcomeMessage, isSender: false)
        
        //        let streamingHandler = StreamingAPIHandler()
        //        streamingHandler.sendPostRequest()
    }
    
    private func appendMessage(_ text: String, isSender: Bool, loading: Bool = false) {
        let message = Message(text: text, isSender: isSender, isLoading: loading)
        messages.append(message)
        tableView.reloadData()
        scrollToLast()
    }
    
    func sendPostRequest(message: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "https://qa.helloalfred.ai/stream_api/bots/knowledge-bot/v1/ask/stream") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(UserDefaults.standard.string(forKey: "Authorization"), forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: String] = ["message": message,"session_id":sessionID ?? ""]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error encoding JSON payload: \(error)")
            return
        }
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        
        let task = session.dataTask(with: request)
        
        self.completionHandler = completion
        
        task.resume()
    }
    
    func removeHTMLTags(from string: String) -> String {
        let regex = try! NSRegularExpression(pattern: "<[^>]+>", options: [])
        let range = NSRange(location: 0, length: string.utf16.count)
        let cleanString = regex.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: "")
        return cleanString
    }
    
    private func updateLastMessage(with text: String) {
        guard !messages.isEmpty else { return }
        messages[messages.count - 1].text += text
        tableView.reloadData()
        scrollToLast()
    }
    func updateMessageApiCall(text:String)
    {
        let params = [
            "message": text
        ] as [String : Any]
        
        inputMessageTextView.isEditable = false
        appendMessage("LOADING", isSender: false,loading: true)
        tableView.reloadData()
        scrollToLast()
        print("params \(params)")
        
        viewModel.updateMessagesToAI(params: params)
        viewModel.chatFetchSuccessfully =
        {
            self.inputMessageTextView.isEditable = true
            self.messages.removeLast()
            self.appendMessage(self.viewModel.chatData?.data?.alfred ?? "", isSender: false)
            
        }
        
        viewModel.errorMessageAlert =
        {
            self.messages.removeLast()
            self.showAlert(self.viewModel.errorMessage ?? "Error")
        }
    }
    
    // MARK: - IQKeyboardManager Handling
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        IQKeyboardManager.shared.isEnabled = textField != inputMessageTextView
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        IQKeyboardManager.shared.isEnabled = true
        return true
    }
    
    // MARK: - Set up initial state of the button
    func setupInitialState() {
        // Disable the record button until authorized and set it to the "microphone" icon
        recordButton.isEnabled = false
        recordButton.setImage(UIImage(named: "microphoneIcon"), for: .normal) // Assume you have a microphone icon in your assets
    }
    
    // MARK: - Record and Send Actions
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        if audioEngine.isRunning {
            // If audio engine is running, stop recording and toggle the button to "send" mode
            stopRecording()
        } else {
            // If audio engine is not running, start recording and set the button to "recording" mode
            startRecording()
        }
    }
    
    func startRecording() {
        // Ensure there's no ongoing recognition task
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        // Start audio session and speech recognition request
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        let inputNode = audioEngine.inputNode
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { result, error in
            var lastSpeechTimestamp = Date()
            
            if let result = result {
                // Update the text view with the recognized speech
                
                print("result.bestTranscription.formattedString \(result.bestTranscription.formattedString)")
                if(result.bestTranscription.formattedString != "" && result.bestTranscription.formattedString != nil)
                {
                    self.inputMessageTextView.text = result.bestTranscription.formattedString
                    self.tempVoiceText = result.bestTranscription.formattedString
                    lastSpeechTimestamp = Date()
                }
                
                
                // Update timestamp whenever speech is detected
            }
            
            // Stop recording if no speech is detected for 2 seconds
            let silenceTimeout: TimeInterval = 2.0
            DispatchQueue.main.asyncAfter(deadline: .now() + silenceTimeout) {
                if Date().timeIntervalSince(lastSpeechTimestamp) >= silenceTimeout {
                    self.stopRecording() // Stop recording due to silence
                }
            }
            
            if error != nil || result?.isFinal == true {
                // Once done, stop the audio engine and reset button state to "send"
                self.stopRecording()
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try? audioEngine.start()
        
        // Change button to "send" icon after starting the recording
        recordButton.setImage(UIImage(named: "stop"), for: .normal) // Use a paper plane icon for sending
    }
    
    
    func stopRecording() {
        inputMessageTextView.text = tempVoiceText
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        
        // Remove the tap from the input node
        audioEngine.inputNode.removeTap(onBus: 0)
        
        // Change button back to "record" icon
        recordButton.setImage(UIImage(named: "microphoneIcon"), for: .normal)
        
        //        // If needed, handle the sending of recognized text here
        //        if let textToSend = inputMessageTextView.text, !textToSend.isEmpty {
        //            sendText()
        //        }
    }
    
    // MARK: - Handle sending of recognized text
    func sendText(text: String) {
        print("Text to send: \(text)")
        // Here, you can handle sending the text (e.g., posting to a server, displaying in a chat, etc.)
    }
    
    // MARK: - SFSpeechRecognizerDelegate Methods
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        recordButton.isEnabled = available
    }
}


extension EducationalChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Ensure this is 1, regardless of `messages` content.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
        cell.messageLabel.sizeToFit()
        cell.messageLabel.numberOfLines = 0
        cell.dataLoading = dataLoading
        cell.showLikeView = true
        
        print("dataaa0 \(messages.count-1) \(indexPath.row)  \(indexPath.row == (messages.count - 1) ? true : false)")
        var val = indexPath.row == (messages.count - 1) ? true : false
        print("dataaa2 \(val)")
        cell.lastMessage = val
        cell.configure(with: messages[indexPath.row], idx: indexPath.row)
        
        cell.commentButtonTappedHandler = {
            self.navigateTo(viewController: ChatFeedbackViewController.self, withIdentifier: "ChatFeedbackViewController")
        }
        cell.speakButtonTappedHandler = {
            if self.speechSynthesizer.isSpeaking {
                // Stop speaking immediately (or .word if you want it to finish the current word)
                cell.speakButton.setImage(UIImage(named: "speak"), for: .normal)
                self.speechSynthesizer.stopSpeaking(at: .immediate)
                print("Speech stopped")
            }
            else
            {
                cell.speakButton.setImage(UIImage(named: "stop"), for: .normal)
                self.speakText(textToSpeak: self.removeHTMLTags(from: self.messages[indexPath.row].text))
            }
            
        }
        cell.copyButtonTappedHandler = {
            // Copy the text to the clipboard
            cell.copyButton.setImage(UIImage(named: "copied"), for: .normal)
            UIPasteboard.general.string = self.removeHTMLTags(from: self.messages[indexPath.row].text)
            self.showAlert("Text copied to clipboard")
        }
        cell.shareButtonTappedHandler = {
    
            self.showEmailPopup(for: self.messages[indexPath.row], index: indexPath.row)
//            self.shareText(text: self.removeHTMLTags(from:self.messages[indexPath.row].text))
        }
        cell.dislikeButtonTappedHandler = {
            self.messages[indexPath.row].isLiked = false
            self.messages[indexPath.row].isDisLiked = true
            self.messages[indexPath.row].isDislikePopupOpened = true
            self.tableView.reloadRows(at: [indexPath], with: .none)
            let params = [
                "question": self.messages[indexPath.row - 1].text,
                "message": self.messages[indexPath.row].text,
                "preference": false,
                "comment": "",
            ]
            self.eduChatViewModel.preferenceChat(params: params)
        }
        cell.likeButtonTappedHandler = {
            self.messages[indexPath.row].isLiked = true
            self.messages[indexPath.row].isDisLiked = false
            self.messages[indexPath.row].isDislikePopupOpened = false
            self.tableView.reloadRows(at: [indexPath], with: .none)
            self.showPillToast(message: "😊 Glad you liked this answer.")
        }
        cell.dislikeMoreButtonTappedHandler = { chipName in
            // Handle the dislike button action here
            if(chipName == "more")
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let currentViewController = storyboard.instantiateViewController(withIdentifier: "ChatFeedbackViewController") as? ChatFeedbackViewController {

                    currentViewController.remarkText = { remark in
                        let params = [
                            "question": self.messages[indexPath.row - 1].text,
                            "message": self.messages[indexPath.row].text,
                            "preference": false,
                            "comment": remark ?? "",
                        ]
                        self.eduChatViewModel.preferenceChat(params: params)
                        self.showPillToast(message: "😊 Thanks for your feedback.")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            cell.feedbackView.isHidden = true
                            self.messages[indexPath.row].isDislikePopupOpened = false
                            self.tableView.reloadRows(at: [indexPath], with: .fade)
                        })
                    }
                     
                    currentViewController.modalPresentationStyle = .overCurrentContext
                    self.present(currentViewController, animated: true)
                }
            } else {
                cell.feedbackView.isHidden = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    cell.feedbackView.isHidden = true
                    self.messages[indexPath.row].isDislikePopupOpened = false
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                })
            }
            
        }
        // Set the close button tapped handler
        cell.closeButtonTappedHandler = { [weak self] in
            guard let self = self else { return }
            self.messages[indexPath.row].isDislikePopupOpened = false
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        cell.reGenerateButtonTappedHandler = {
            self.removeElements(from: indexPath.row)
        }
        
        return cell
    }
    
    
    private func showEmailPopup(for msg: Message, index: Int) {
        let popupView = CustomEmailPopupView()
        popupView.show(in: view)
        
        popupView.onSubmitTapped = {
            print("Submit button tapped!")
            let params = [
                "bot_msg": msg.text,
                "user_msg" : self.messages[index - 1].text
            ]
            APIClient.shareChatToEmail(params: params, completion: { response in
                print("Submit button tapped!")
                switch response {
                case .success(let res):
                    self.showAlert(res.message ?? "")
                case.failure(let err):
                    print(err.localizedDescription)
                    self.showAlert(err.localizedDescription ?? "")
                }
            })
        }
        
        popupView.onCancelTapped = {
            print("Cancel button tapped!")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
extension EducationalChatViewController: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        // Process the data as it arrives
        if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            DispatchQueue.main.async {
                self.completionHandler?("Received JSON chunk: \(jsonResponse)")
            }
        } else {
            let stringResponse = String(data: data, encoding: .utf8)
            DispatchQueue.main.async {
                self.completionHandler?(stringResponse ?? "Unknown data format")
            }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        self.inputMessageTextView.isEditable = true
        dataLoading = false
        tableView.reloadData()
        
        if let error = error {
            print("Error completing request: \(error)")
        } else {
            print("Request completed successfully")
        }
    }
    
    
}


