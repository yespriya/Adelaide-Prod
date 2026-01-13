//
//  BehaviouralChatViewController.swift
//  HelloAlfred
//
//  Created by admin on 11/06/24.
//

import UIKit
import IQKeyboardManagerSwift

class BehaviouralChatViewController: BaseViewController, KeyboardHandling {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var messageInputTextView: InputTextView!
    @IBOutlet var textViewHeightConstraint: NSLayoutConstraint!
    var viewModel = ChatViewModel()
    var profileCompletion: ProfileCompletionModel?
    var messages: [Message] = []
    var questions: [[String]]?
    var currentQuestion = String()
    var questionGroup = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupKeyboardObservers()
        getQuestions()
        textViewHeightConstraint.isActive = false
        messageInputTextView.placeholder = "Enter your message"
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }

    // MARK: - Setup Methods

    private func setupTableView() {
        tableView.register(UINib(nibName: "MessageTableViewCell", bundle: .main), forCellReuseIdentifier: "MessageTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Actions

    @IBAction func sendButtonTapped(_ sender: Any) {
        guard let text = messageInputTextView.text, !text.isEmpty else {
            showAlert("Please enter a text")
            return
        }

        appendMessage(text, isSender: true)
        updateUserApiCall(text: text)
        messageInputTextView.text = ""
    }

    @IBAction func backPressed(_ sender: Any) {
        
        navigateTo(viewController: DashboardViewController.self, withIdentifier: "DashboardViewController")
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

    // MARK: - Questions Handling
    
    //Display the 1st message as static welcome message
    private func initializeChat() {
        let welcomeMessage = """
        Welcome to the Patient Personality Questionnaire, my name Alfred and I'll be leading you through a series of 17 behavioral questions.
        Please rate your agreement with the following questions on a scale of 1 to 10. 'Strongly Disagree' corresponds to a 1, while 'Strongly Agree' would be a 10.
        Let's get started!
        """
        appendMessage(welcomeMessage, isSender: false)
        presentNextQuestion()
    }

    
    private func presentNextQuestion() {
        if questions?.isEmpty ?? true {
            return
        }
        guard let questionsGroup = questions?[questionGroup - 1] else { return }
        currentQuestion = questionsGroup[generateRandomNumber(count: questionsGroup.count)]
        appendMessage(currentQuestion, isSender: false)
    }

    private func generateRandomNumber(count: Int) -> Int {
        return Int(arc4random_uniform(UInt32(count)))
    }

    private func appendMessage(_ text: String, isSender: Bool, loading: Bool = false) {
        let message = Message(text: text, isSender: isSender, isLoading: loading)
        messages.append(message)
        tableView.reloadData()
        scrollToLast()
    }


     func scrollToLast() {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if lastRowIndex >= 0 {
            let indexPath = IndexPath(row: lastRowIndex, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    // MARK: - API Calls

    private func updateUserApiCall(text: String) {
        messageInputTextView.isEditable = false
        appendMessage("LOADING", isSender: false,loading: true)

        let params: [String: Any] = [
            "alfred": currentQuestion,
            "questionno": questionGroup,
            "user": text
        ]
        
        viewModel.updateAnswer(params: params)
        viewModel.questionUpdatedSuccessfully = {
            self.messageInputTextView.isEditable = true
            self.messages.removeLast()
            
            // Handling different status codes returned by the API
            if let statusCode = self.viewModel.questionUpdatedData?.status_code {
                
                switch statusCode {
                case -1:
                    // Status code -1 indicates an invalid answer entered by the user
                    self.appendMessage(self.viewModel.questionUpdatedData?.message ?? "", isSender: false)

                case 99:
                    // Status code 99 indicates the user has completed all the answers
                    self.appendMessage(self.viewModel.questionUpdatedData?.message ?? "", isSender: false)
                    self.showButton()

                default:
                    if self.questionGroup % 3 == 0 {
                        // For every 3rd question, show the message from the response and then present the next question
                        self.appendMessage(self.viewModel.questionUpdatedData?.message ?? "", isSender: false)
                    }
                    // Move to the next question
                    self.questionGroup += 1
                    self.presentNextQuestion()
                }
            }

        }

        viewModel.errorMessageAlert = {
            self.messageInputTextView.isEditable = true
            self.messages.removeLast()
            self.appendMessage("An error occurred. Please try again later.", isSender: false)
        }
    }
    private func getQuestions() {
        viewModel.fetchProfileCompletionStatus(params: ["behavioural_chat": true])
        viewModel.profileCompletionFetchSuccess = {
            self.profileCompletion = self.viewModel.profileCompletionRes
            if self.profileCompletion?.data != nil {
                self.showAlertWithHandler(message: self.profileCompletion?.message ?? "", okActionTitle: "Ok", enableCancel: true, okActionHandler: {_ in 
                    self.navigateTo(viewController: HistoryChatViewController.self, withIdentifier: "HistoryChatViewController")
                }, cancelActionHandler: { _ in
                    self.dismiss(animated: true)
                })
            }
        }
        viewModel.getChatQuestions()
        viewModel.questionFetchSuccessfully = {
            self.questions = self.viewModel.questionData?.data
            self.initializeChat()
        }
        
        viewModel.errorMessageAlert = {
            self.showAlert(self.viewModel.errorMessage ?? "Error")
        }
    }
    
    // MARK: - Button

    private func showButton() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        
        let button = UIButton(type: .system)
        button.setTitle("Go to Dashboard", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 14)
        button.backgroundColor = UIColor(named: "AppTheme")
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        containerView.addSubview(button)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 80),
            
            button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            button.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - IQKeyboardManager Handling

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        IQKeyboardManager.shared.isEnabled = true
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        IQKeyboardManager.shared.isEnabled = true
        return true
    }
}

extension BehaviouralChatViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return messages.isEmpty ? 0 : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
        cell.configure(with: messages[indexPath.row], idx: indexPath.row)
        cell.messageLabel.sizeToFit()
        cell.messageLabel.numberOfLines = 0
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

