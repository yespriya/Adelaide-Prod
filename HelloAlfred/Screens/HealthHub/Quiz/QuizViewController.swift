//
//  QuizViewController.swift
//  HelloAlfred
//
//  Created by SS on 07/08/25.
//

import UIKit

class QuizViewController: UIViewController {

    @IBOutlet weak var btnNextQue: Mybutton!
    @IBOutlet weak var btnPreviousQue: Mybutton!
    @IBOutlet weak var vwBackAndNext: UIView!
    @IBOutlet weak var vwSubmit: UIView!
    @IBOutlet weak var lblExplanation: UILabel!
    @IBOutlet weak var btnSubmit: Mybutton!
    @IBOutlet weak var btnRestart: Mybutton!
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var lblDisclaimer: UILabel!
    @IBOutlet weak var optionStack: UIStackView!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var quizProgress: UIProgressView!
    @IBOutlet weak var lblModule: UILabel!
    
    let viewModel = QuizViewModel()
    var quizKey = ""
    
    var quizData: QuestionData?
    
    var totalQuestionCount: Int = 0
    var currentQuestionCount: Int = 0
    var completedQuestionCount: Int = 0
    var currentQuestionIndex: Int = 0
    
    var simpleOptions: [SimpleOptionView] = []
    var isMultipleSelection: Bool = false
    var selecxtedOptions: [String] = []
    var selectedOption: String = ""
    
    var inputOptionView: InputOptionView?
    var scaleOptionView: ScaleOptionView?
    
    var selectedScaleOption: Int = 0
    var selectedScaleOptionText: String = ""
    
    var explanationMessage = "💡 Explanation"
    
    var isBtnNext = true
    var isAnswerSubmitted: Bool = false
    var type = ""
    var moduelDisplyNumber: String = ""
    var nextWeekQuizKey_pretest: String = ""
    
    var attemptedQuestions: Set<Int> = []
    
    var needToUpdateWeekStatus: ((Bool) -> Void)?
    // store generic answers (single/multiple/input/scale label)
    var savedAnswers: [Int: [String]] = [:]

    // store scale numeric value if you need the integer too
    var savedScaleValues: [Int: Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()

//        self.activityIndicator(view.self, startAnimate: true)
        viewModel.fetchQuizData(with: ["week_number" : quizKey.replacingOccurrences(of: "module_", with: "")])
        viewModel.quizListFetchSuccess = { [weak self] in
            guard let self = self else { return }
            self.activityIndicator(view.self, startAnimate: false)
            self.quizData = self.viewModel.quizResponse?.data
            
            setQuizData()
        }
        
        viewModel.errorMessageAlert = { [weak self] in
            guard let self = self else { return }
            self.activityIndicator(view.self, startAnimate: false)
            self.showAlert(self.viewModel.errorMessage ?? "Error")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.isHidden = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.view.isHidden = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

    @IBAction func btnCloseAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnRestartAction(_ sender: UIButton) {
        
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        if isBtnNext && isAnswerSubmitted {
            completedQuestionCount += 1
            currentQuestionCount += 1
            currentQuestionIndex += 1
            setQuestionData()
        } else {
            guard (quizData?.questions?[currentQuestionIndex]) != nil else { return }
            evaluateAnswer()
        }
    }
    
    @IBAction func btnPreviousQue(_ sender: Any) {
        // Move to previous question if available
        guard currentQuestionIndex > 0 else { return }
        currentQuestionIndex -= 1
        currentQuestionCount = currentQuestionIndex + 1
        // When navigating, we shouldn't change completedQuestionCount here
        setQuestionData()
    }
    
    @IBAction func btnNextQue(_ sender: Any) {
        // Move to next question only if it exists and has been attempted
        guard let questions = quizData?.questions else { return }
        let nextIndex = currentQuestionIndex
        guard nextIndex < questions.count else { return }
        guard attemptedQuestions.contains(nextIndex) else {
            // Optionally show a brief message to user
            // e.g. showToast("Answer the question first to enable Next") or do nothing
            return
        }
        currentQuestionIndex = nextIndex + 1
        currentQuestionCount = currentQuestionIndex + 1
        setQuestionData()
    }
    
    // MARK: - Update the back/next visibility
    func updateBackNextButtonsVisibility() {
        // Back visible when there is a previous question
        btnPreviousQue.isHidden = currentQuestionIndex == 0
        vwBackAndNext.isHidden = false // keep the container visible if you want
        
        // Next visible only when the next question exists AND is attempted
        if let questions = quizData?.questions {
            let nextIndex = currentQuestionIndex
            if nextIndex < questions.count && attemptedQuestions.contains(nextIndex) {
                btnNextQue.isHidden = true
            } else {
                btnNextQue.isHidden = true
            }
        } else {
            btnNextQue.isHidden = true
        }
        
        self.vwBackAndNext.isHidden = btnNextQue.isHidden && btnPreviousQue.isHidden
    }
    
    func evaluateAnswer() {
        guard let question = quizData?.questions?[currentQuestionIndex] else { return }
        
        let answer: [String] = {
            switch type {
            case "survey", "single":
                return [selectedOption]
            case "multiple":
                return selecxtedOptions
            case "input":
                return [inputOptionView?.tvAnswers.text ?? ""]
            case "scale":
                return [selectedScaleOptionText]
            default:
                return []
            }
        }()
        
        let param: [String: Any] = [
            "question_number": question.questionNo ?? 0,
            "question": question.question ?? "",
            "answer": answer,
            "week_number": quizKey,
            "choice": question.choice ?? "",
            "scale": type == "scale" ? selectedScaleOption : NSNull(),
            "label": type == "scale" ? selectedScaleOptionText : ""
        ]
        print(param)
        self.activityIndicator(view.self, startAnimate: true)
        
        viewModel.evaluateAnswer(with: param) { [weak self] data in
            guard let self = self else { return }
            
            self.activityIndicator(view.self, startAnimate: false)
            
            // Mark the current question as attempted (regardless of correctness),
            // so user can navigate forward to it later.
            self.attemptedQuestions.insert(self.currentQuestionIndex)
            
            self.savedAnswers[self.currentQuestionIndex] = answer
            if self.type == "scale" {
                self.savedScaleValues[self.currentQuestionIndex] = self.selectedScaleOption
            }
            
            if !self.isBtnNext {
                if data.answer_status ?? false {
                    self.simpleOptions.forEach { option in
                        if option.isSelectedOption {
                            option.imgRadioButton.tintColor = .systemGreen
                            option.imgCheckBoxButton.tintColor = .systemGreen
                            option.lblOption.textColor = .systemGreen
                        }
                    }
                    
                    if let explanation = data.explanation, !explanation.isEmpty {
                        self.setupExplanationText(with: explanation, color: .systemGreen)
                    }
                } else {
                    self.simpleOptions.forEach { option in
                        if option.isSelectedOption {
                            option.imgRadioButton.tintColor = .red
                            option.imgCheckBoxButton.tintColor = .red
                            option.lblOption.textColor = .red
                        }
                    }
                    if let explanation = data.explanation, !explanation.isEmpty {
                        self.setupExplanationText(with: explanation, color: .red)
                    }
                }
                self.isBtnNext = true
                self.isAnswerSubmitted = true
                if let feedback_status = data.feedback_status, feedback_status {
                    self.isBtnNext = false
                    self.isAnswerSubmitted = false
                    completedQuestionCount += 1
                    currentQuestionCount += 1
                    currentQuestionIndex += 1
                    setQuestionData()
                }
                if currentQuestionCount == totalQuestionCount {
                    btnSubmit.setTitle("Submit", for: .normal)
                }
                else{
                    self.btnSubmit.setTitle("Submit", for: .normal)
                }
            } else {
                self.isBtnNext = true
                self.isAnswerSubmitted = true
                self.btnSubmitAction(UIButton())
            }
            // Update back/next button visibility right after evaluation returns
            self.updateBackNextButtonsVisibility()
        }
    }
}

//MARK: - All Methos
extension QuizViewController {
    
    func setupUI() {

        self.lblModule.text = moduelDisplyNumber//"Module \(quizKey)"
        setupDesclimer()
    }
    
    func setupDesclimer() {
        let boldText = "Disclaimer:"
        let normalText = " This quiz is designed solely to assess your basic understanding level. Your scores will not be used for any grading or formal evaluation. Please avoid using AI tools or Google while answering the quiz to ensure accurate assessment of your knowledge."

        // Create fonts
        let boldFont = UIFont(name: "Poppins-SemiBold", size: 14)!
        let regularFont = UIFont(name: "Poppins-Regular", size: 14)!

        // Create attributed string
        let attributedString = NSMutableAttributedString(
            string: boldText,
            attributes: [
                .font: boldFont,
                .foregroundColor: UIColor.label
            ]
        )

        let normalAttributed = NSAttributedString(
          string: normalText,
            attributes: [
                .font: regularFont,
                .foregroundColor: UIColor.gray
            ]
        )

        attributedString.append(normalAttributed)
        lblDisclaimer.attributedText = attributedString
    }
    
    func setupExplanationText(with text: String, color: UIColor) {
        let boldText = explanationMessage
        let normalText = " \(text)"

        // Create fonts
        let boldFont = UIFont(name: "Poppins-Regular", size: 14)!
        let regularFont = UIFont(name: "Poppins-Regular", size: 14)!

        // Create attributed string
        let attributedString = NSMutableAttributedString(
            string: boldText,
            attributes: [
                .font: boldFont,
                .foregroundColor: UIColor.black
            ]
        )

        let normalAttributed = NSAttributedString(
            string: normalText,
            attributes: [
                .font: regularFont,
                .foregroundColor: color
            ]
        )

        attributedString.append(normalAttributed)
        lblExplanation.attributedText = attributedString
    }
    
    func setQuizData() {
        self.totalQuestionCount = self.quizData?.questionCount ?? 0
        self.completedQuestionCount = self.totalQuestionCount - (self.quizData?.questions?.count ?? 0)
        self.currentQuestionCount = completedQuestionCount + 1
        
        self.setQuestionData()
    }
    
    func setQuizProgress() {
        self.quizProgress.setProgress(Float(completedQuestionCount) / Float(totalQuestionCount), animated: true)
        let percentage = Int(Float(completedQuestionCount) / Float(totalQuestionCount) * 100)
        self.lblProgress.text = "\(percentage)% Completed | \(completedQuestionCount) of \(totalQuestionCount) Completed"
    }
    
    func resetQuestionData() {
        self.simpleOptions.forEach({ $0.removeFromSuperview() })
        self.optionStack.subviews.forEach({ $0.removeFromSuperview() })
        self.simpleOptions.removeAll()
        self.selectedOption = ""
        self.selecxtedOptions.removeAll()
        
        self.selectedScaleOption = 0
        self.selectedScaleOptionText = ""
        
        self.isMultipleSelection = false
        self.isAnswerSubmitted = false
        
        self.view.layoutIfNeeded()
    }
    
    func setQuestionData() {
        
        self.resetQuestionData()
        self.setQuizProgress()
        
        if currentQuestionCount > totalQuestionCount {
            vwBackAndNext.isHidden = true
            let weekNumber =  quizKey.replacingOccurrences(of: "module_", with: "")
            if weekNumber == "pre_test" && totalQuestionCount == 1 {
                fetchNextWeekData()
                return
            }
            let alert = UIAlertController(title: "Hello Alfred", message: "You Completed All Questions", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                self.needToUpdateWeekStatus?(true)
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard let question = quizData?.questions?[currentQuestionIndex] else { return }
        
        self.lblQuestion.text = "\(currentQuestionCount). \(question.question ?? "")"
        if let comment = question.comment, !comment.isEmpty {
            lblComment.text = "Comment : \(comment)"
        } else {
            lblComment.isHidden = true
        }
        
        self.btnSubmit.isUserInteractionEnabled = false
        self.btnSubmit.alpha = 0.7
        self.vwSubmit.isHidden = false
        
        self.lblExplanation.text = ""
        
        type = question.choice ?? ""
        
        if type == "survey" || type == "multiple" || type == "single" {
            self.isMultipleSelection = type == "multiple"
            if let options = question.options {
                optionStack.subviews.forEach { $0.removeFromSuperview() }
                var cnt = 0
                options.forEach { option in
                    let optionView = SimpleOptionView()
                    optionStack.addArrangedSubview(optionView)
                    
                    optionView.lblOption.text = option
                    optionView.isMultipleOption = self.isMultipleSelection
                    optionView.isSelectedOption = false
                    
                    optionView.btnOption.tag = cnt
                    cnt += 1
                    
                    optionView.btnOption.addTarget(self, action: #selector(handleSimpleOptionSelection), for: .touchUpInside)
                    
                    self.simpleOptions.append(optionView)
                }
                
                self.view.layoutSubviews()
                self.view.layoutIfNeeded()
            }
            
            isBtnNext = false
            if currentQuestionCount == totalQuestionCount {
                btnSubmit.setTitle("Submit", for: .normal)
            }
            else{
                btnSubmit.setTitle("Submit", for: .normal)
            }
            if (question.issubmitbtn ?? false) {
                isBtnNext = false
                vwSubmit.isHidden = false
            } else {
                isBtnNext = true
                vwSubmit.isHidden = !isMultipleSelection
            }
            
            // Restore previously saved selection (if any)
            if let saved = savedAnswers[currentQuestionIndex], !saved.isEmpty {
                if self.isMultipleSelection {
                    // multiple selection: saved is array of selected option strings
                    self.selecxtedOptions = saved
                    // update option views
                    let options = question.options ?? []
                    self.simpleOptions.forEach {
                        let optText = options[$0.btnOption.tag]
                        $0.isSelectedOption = self.selecxtedOptions.contains(optText)
                    }
                    self.btnSubmit.isUserInteractionEnabled = !self.selecxtedOptions.isEmpty
                    self.btnSubmit.alpha = self.selecxtedOptions.isEmpty ? 0.7 : 1.0
                } else {
                    // single selection: saved[0] is selected option
                    self.selectedOption = saved.first ?? ""
                    if let optionView = self.simpleOptions.first(where: { $0.lblOption.text == self.selectedOption }) {
                        optionView.isSelectedOption = true
                    }
                    self.btnSubmit.isUserInteractionEnabled = (self.selectedOption != "")
                    self.btnSubmit.alpha = self.selectedOption == "" ? 0.7 : 1.0
                }
            }

        } else if type == "input" {
            optionStack.subviews.forEach { $0.removeFromSuperview() }
            
            inputOptionView = InputOptionView()
            optionStack.addArrangedSubview(inputOptionView!)
        
            inputOptionView?.onTextChanged = { [weak self] text in
                guard let self = self else { return }
                
                self.view.layoutSubviews()
                self.view.layoutIfNeeded()
                
                self.btnSubmit.isUserInteractionEnabled = !(inputOptionView?.tvAnswers.text.isEmpty ?? true)
                self.btnSubmit.alpha = (inputOptionView?.tvAnswers.text.isEmpty ?? true) ? 0.7 : 1.0
            }
            
            isBtnNext = true
            if currentQuestionCount == totalQuestionCount {
                btnSubmit.setTitle("Submit", for: .normal)
            }
            else{
                btnSubmit.setTitle("Submit", for: .normal)
            }
            
            if let saved = savedAnswers[currentQuestionIndex], let text = saved.first {
                inputOptionView?.tvAnswers.text = text
                // manually trigger the onTextChanged handling to update submit state
                inputOptionView?.onTextChanged?(text)
                self.btnSubmit.isUserInteractionEnabled = !(text.isEmpty)
                self.btnSubmit.alpha = text.isEmpty ? 0.7 : 1.0
            }

            
        } else if type == "scale" {
            optionStack.subviews.forEach { $0.removeFromSuperview() }
            
            scaleOptionView = ScaleOptionView()
            optionStack.addArrangedSubview(scaleOptionView!)
            
            scaleOptionView?.labelMap = question.label ?? [:]
            
            scaleOptionView?.onValueChanged = { [weak self] value, label in
                guard let self = self else { return }
                
                self.selectedScaleOption = value
                self.selectedScaleOptionText = label
            }
            
            if !(question.issubmitbtn ?? false) {
                scaleOptionView?.onValueChangedEnd = { [weak self] values, label in
                    guard let self = self else { return }
                    
                    self.selectedScaleOption = values
                    self.selectedScaleOptionText = label
                    
                    self.btnSubmitAction(UIButton())
                }
            }
            
            self.btnSubmit.isUserInteractionEnabled = true
            self.btnSubmit.alpha = 1
            
            isBtnNext = false
            if currentQuestionCount == totalQuestionCount {
                btnSubmit.setTitle("Submit", for: .normal)
            }
            else{
                btnSubmit.setTitle("Submit", for: .normal)
            }
            self.selectedScaleOption = Int(question.label?.keys.first ?? "1") ?? 1
            self.selectedScaleOptionText = question.label?.values.first ?? ""
            if !(question.issubmitbtn ?? false) {
                isBtnNext = true
                vwSubmit.isHidden = false
            }
            
            if let saved = savedAnswers[currentQuestionIndex], let savedLabel = saved.first {
                // restore label text
                self.selectedScaleOptionText = savedLabel
            }

            // restore numeric if available
            if let savedValue = savedScaleValues[currentQuestionIndex] {
                self.selectedScaleOption = savedValue
                // programmatically set slider and update UI
                scaleOptionView?.setSelectedValue(savedValue, shouldSendCallback: false)
            } else if let label = savedAnswers[currentQuestionIndex]?.first {
                // fallback: try find numeric key by label text
                if let foundKey = question.label?.first(where: { $0.value == label })?.key, let intKey = Int(foundKey) {
                    self.selectedScaleOption = intKey
                    self.savedScaleValues[currentQuestionIndex] = intKey
                    scaleOptionView?.setSelectedValue(intKey, shouldSendCallback: false)
                }
            }

            // also ensure the controller's state uses the restored values
            self.selectedScaleOptionText = question.label?["\(self.selectedScaleOption)"] ?? self.selectedScaleOptionText
        }
        
        // Update visibility of back / next buttons for this question
        updateBackNextButtonsVisibility()
    }
    
    @objc func handleSimpleOptionSelection(_ sender: UIButton) {
        if isMultipleSelection {
            
            guard let question = quizData?.questions?[currentQuestionIndex] else { return }
            
            simpleOptions.forEach { $0.isSelectedOption = false }
            let options = question.options ?? []
            
            if self.selecxtedOptions.contains(options[sender.tag]) {
                self.selecxtedOptions.removeAll { $0 == options[sender.tag] }
            } else {
                self.selecxtedOptions.append(options[sender.tag])
            }
            
            simpleOptions.forEach {
                $0.isSelectedOption = self.selecxtedOptions.contains(options[$0.btnOption.tag])
            }
            
            self.btnSubmit.isUserInteractionEnabled = !self.selecxtedOptions.isEmpty
            self.btnSubmit.alpha = self.selecxtedOptions.isEmpty ? 0.7 : 1.0
        } else {
            simpleOptions.forEach { $0.isSelectedOption = false }
            self.selectedOption = simpleOptions[sender.tag].lblOption.text ?? ""
            if let optionView = simpleOptions.first(where: { $0.lblOption.text == selectedOption }) {
                optionView.isSelectedOption = true
            }
            
            self.btnSubmit.isUserInteractionEnabled = self.selectedOption != ""
            self.btnSubmit.alpha = self.selectedOption == "" ? 0.7 : 1.0
            
            self.btnSubmitAction(UIButton())
        }
    }
    
    func fetchNextWeekData() {
        viewModel.fetchQuizData(with: ["week_number" : quizKey.replacingOccurrences(of: "module_", with: "")])
        viewModel.quizListFetchSuccess = { [weak self] in
            guard let self = self else { return }
            self.activityIndicator(view.self, startAnimate: false)
            self.quizData = self.viewModel.quizResponse?.data
         //   quizKey = self.nextWeekQuizKey_pretest
             totalQuestionCount = 0
             currentQuestionCount = 0
             completedQuestionCount = 0
             currentQuestionIndex = 0
            setQuizData()
        }
    }
}
