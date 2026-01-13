import UIKit
import IQKeyboardManagerSwift

class HistoryChatViewController: BaseViewController, KeyboardHandling {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var messageInputTextView: InputTextView!
    @IBOutlet var textViewHeightConstraint: NSLayoutConstraint!
    
    var messages: [Message] = []
    var viewModel = ChatViewModel()
    var questions: InitialQuestionData?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getInitialQuestion()
        setupKeyboardObservers()
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

    // MARK: - Keyboard Handling
    func adjustForKeyboard(notification: NSNotification, show: Bool) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        bottomConstraint.constant = show ? keyboardFrame.height + 20 : 20
        UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
        scrollToLast()
    }

     func scrollToLast() {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if lastRowIndex >= 0 {
            tableView.scrollToRow(at: IndexPath(row: lastRowIndex, section: 0), at: .bottom, animated: true)
        }
    }
    
    // MARK: - Actions
    @IBAction func sendButtonTapped(_ sender: Any) {
        guard let text = messageInputTextView.text, !text.isEmpty else {
            showAlert("Please enter a text")
            return
        }
        addMessage(text, isSender: true)
        updateUserApiCall(text: text)
        messageInputTextView.text = ""
    }

    @IBAction func backPressed(_ sender: Any) {
        navigateToViewController(withIdentifier: "DashboardViewController")
    }

    @IBAction func formClicked(_ sender: Any) {
        navigateToViewController(withIdentifier: "HistoryChatFormViewController")
    }
    
    private func navigateToViewController(withIdentifier identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: false, completion: nil)
    }

    // MARK: - Message Handling
    private func addMessage(_ text: String, isSender: Bool, loading: Bool = false) {
        let message = Message(text: text, isSender: isSender, isLoading: loading)
        messages.append(message)
        tableView.reloadData()
        scrollToLast()
    }
    
    // MARK: - API Calls
    private func getInitialQuestion() {
        viewModel.fetchInitialHistoryQuestions()
        viewModel.initialHistoryQuestionFetchSuccessfully = {
            self.questions = self.viewModel.initialHistoryQuestionRes?.data
            self.initializeChat()
        }
        viewModel.errorMessageAlert = {
            self.showAlert(self.viewModel.errorMessage ?? "Error")
        }
    }

    private func initializeChat() {
        let welcomeText = "Welcome to the Patient Personality Questionnaire, my name is Alfred and I'll be leading you through a series of questions. \n\nLet's get started!"
        addMessage(welcomeText, isSender: false)
        if let initialQuestion = questions?.description {
            addMessage(initialQuestion, isSender: false)
        }
    }

    private func updateNextQuestion() {
        if let updatedQuestion = viewModel.historyChatQuestionUpdatedRes?.data?.description {
            addMessage(updatedQuestion, isSender: false)
        }
    }
    

    private func updateUserApiCall(text: String) 
    {
        messageInputTextView.isEditable = false
        addMessage("LOADING", isSender: false,loading: true)
        let params: [String: Any] = [
            "question": questions?.description ?? "",
            "user_message": text,
            "question_key": questions?.question_key ?? "",
            "main_type": questions?.main_type ?? "",
            "ans_categ": questions?.ans_category ?? ""
        ]
        
        print("params \(params)")
        viewModel.updateHistoryChatQuestion(params: params)
        handleApiResponse()
    }
    
    private func handleApiResponse() {
        viewModel.historyChatQuestionUpdatedSuccessfully = {
            
            DispatchQueue.main.async {
                self.messageInputTextView.isEditable = true
                self.messages.removeLast() // Remove the loading message
                guard let response = self.viewModel.historyChatQuestionUpdatedRes else { return }
                if response.statuscode == -1 {
                    self.addMessage(response.message ?? "", isSender: false)
                } else if response.statuscode == 99 || response.statuscode == 404 {
                    self.addMessage(response.message ?? "", isSender: false)
                    self.showButton()
                } else if let message = response.message, !message.isEmpty {
                    self.addMessage(message, isSender: false)
                    self.updateNextQuestion()
                } else {
                    self.updateNextQuestion()
                }
            }
        }
        viewModel.errorMessageAlert = 
        {
            DispatchQueue.main.async {
                self.messageInputTextView.isEditable = true
                self.messages.removeLast() // Remove the loading message
                self.addMessage("An error Occured Please try again", isSender: false)
            }
        }
    }
    
    // MARK: - IQKeyboardManager Handling
    
    //disable IQKeyboard manager for scrolling issues
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        IQKeyboardManager.shared.isEnabled = (textField != messageInputTextView)
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        IQKeyboardManager.shared.isEnabled = true
        return true
    }

    // MARK: - UI Updates
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
}




// MARK: - UITableViewDelegate, UITableViewDataSource
extension HistoryChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messages.isEmpty {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No Questions Available"
            noDataLabel.textColor = .black
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
            return 0
        } else {
            tableView.backgroundView = nil
            return messages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
        let message = messages[indexPath.row]
        cell.configure(with: message, idx: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

