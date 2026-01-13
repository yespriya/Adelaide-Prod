import Foundation
import UIKit

class ChatViewModel {
    // Properties
    var chatData: ChatModel? {
        didSet { self.chatFetchSuccessfully?() }
    }
    var initialHistoryQuestionRes: HistoryChatQuestionModel? {
        didSet { self.initialHistoryQuestionFetchSuccessfully?() }
    }
    var questionUpdatedData: QuestionUpdateResModel? {
        didSet { self.questionUpdatedSuccessfully?() }
    }
    var historyChatQuestionUpdatedRes: HistoryChatQuestionModel? {
        didSet { self.historyChatQuestionUpdatedSuccessfully?() }
    }
    var historyFormAnswersUpdatedData: QuestionUpdateResModel? {
        didSet { self.historyFormAnswersUpdatedSuccessfully?() }
    }
    var questionData: QuestionsResModel? {
        didSet { self.questionFetchSuccessfully?() }
    }
    var historyChatData: HistoryChatModel? {
        didSet { self.historyChatFetchSuccessfully?() }
    }
    
    var profileCompletionRes: ProfileCompletionModel? {
        didSet {
            self.profileCompletionFetchSuccess?()
        }
    }
    var error: Error? {
        didSet { self.errorMessageAlert?() }
    }
    var errorMessage: String?
    var isLoading: Bool = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.loadingStatus?()
            }
        }
    }

    
    // Closures for callback
    var chatFetchSuccessfully: (() -> Void)?
    var profileCompletionFetchSuccess: (() -> Void)?
    var initialHistoryQuestionFetchSuccessfully: (() -> Void)?
    var questionFetchSuccessfully: (() -> Void)?
    var questionUpdatedSuccessfully: (() -> Void)?
    var historyChatQuestionUpdatedSuccessfully: (() -> Void)?
    var historyFormAnswersUpdatedSuccessfully: (() -> Void)?
    var historyChatFetchSuccessfully: (() -> Void)?
    var loadingStatus: (() -> Void)?
    var errorMessageAlert: (() -> Void)?
    
    func fetchProfileCompletionStatus(params: [String: Any]) {
        isLoading = true

        APIClient.fetchProfileCompletion(params: params) { result in
            self.isLoading = false

            switch result {
            case .success(let responseData):
                guard let statusCode = responseData.statuscode else {
                    self.errorMessage = "Unknown Error: Status code is nil"
                    self.errorMessageAlert?()
                    return
                }

                switch statusCode {
                case 200..<300:
                    self.profileCompletionRes = responseData
                case 401:
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.redirectToLogin(errorMsg: responseData.message)
                    }
                case 400..<501:
                    self.errorMessage = responseData.message
                    self.errorMessageAlert?()
                default:
                    debugPrint("Unknown Error: Status code \(statusCode)")
                }

            case .failure(let error):
                debugPrint("Request failed with error: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                self.error = error
            }
        }
    }
    
    func updateMessagesToAI(params: [String: Any]) {
        isLoading = true
        APIClient.updateMessagesToAI(params: params) { result in
            self.isLoading = false
            switch result {
            case .success(let responseData):
                guard let statusCode = responseData.statuscode else {
                    debugPrint("Unknown Error: Status code is nil")
                    return
                }

                switch statusCode {
                case 200..<300:
                    self.chatData = responseData
                case 401:
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.redirectToLogin(errorMsg: responseData.message)
                    }
                case 400..<501:
                    self.errorMessage = responseData.message
                    self.errorMessageAlert?()
                default:
                    debugPrint("Unknown Error: Status code \(statusCode)")
                }

            case .failure(let error):
                debugPrint("Request failed with error: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                self.error = error
            }
        }
    }
    
    func updateAnswer(params: [String: Any]) {
        isLoading = true
        APIClient.updateAnswers(params: params) { result in
            self.isLoading = false
            switch result {
            case .success(let responseData):
                guard let statusCode = responseData.status_code else {
                    debugPrint("Unknown Error: Status code is nil")
                    return
                }

                switch statusCode {
                case -1..<300:
                    self.questionUpdatedData = responseData
                case 401:
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.redirectToLogin(errorMsg: responseData.message)
                    }
                case 400..<501:
                    self.errorMessage = responseData.message
                    self.errorMessageAlert?()
                default:
                    debugPrint("Unknown Error: Status code \(statusCode)")
                }

            case .failure(let error):
                debugPrint("Request failed with error: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                self.error = error
            }
        }
    }
    
    func updateHistoryChatQuestion(params: [String: Any]) {
        isLoading = true
        APIClient.updateHistoryChatQuestions(params: params) { result in
            self.isLoading = false
            switch result {
            case .success(let responseData):
                guard let statusCode = responseData.statuscode else {
                    debugPrint("Unknown Error: Status code is nil")
                    return
                }

                switch statusCode {
                case -1..<300:
                    self.historyChatQuestionUpdatedRes = responseData
                case 401:
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.redirectToLogin(errorMsg: responseData.message)
                    }
                case 400..<501:
                    self.errorMessage = responseData.message
                    self.errorMessageAlert?()
                default:
                    debugPrint("Unknown Error: Status code \(statusCode)")
                }

            case .failure(let error):
                debugPrint("Request failed with error: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                self.error = error
            }
        }
    }
    
    func updateHistoryFormAnswers(params: [String: Any]) {
        isLoading = true
        APIClient.updateHistoryFormAnswers(params: params) { result in
            self.isLoading = false
            switch result {
            case .success(let responseData):
                guard let statusCode = responseData.status_code else {
                    debugPrint("Unknown Error: Status code is nil")
                    return
                }
                switch statusCode {
                case 0..<300:
                    self.historyFormAnswersUpdatedData = responseData
                case 401:
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.redirectToLogin(errorMsg: responseData.message)
                    }
                case 400..<501:
                    self.errorMessage = responseData.message
                    self.errorMessageAlert?()
                default:
                    debugPrint("Unknown Error: Status code \(statusCode)")
                }

            case .failure(let error):
                debugPrint("Request failed with error: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                self.error = error
            }
        }
    }
    
    func getChatQuestions() {
        isLoading = true
        APIClient.fetchChatQuestions { result in
            self.isLoading = false
            switch result {
            case .success(let responseData):
                guard let statusCode = responseData.statuscode else {
                    debugPrint("Unknown Error: Status code is nil")
                    return
                }

                switch statusCode {
                case 200..<300:
                    self.questionData = responseData
                case 401:
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.redirectToLogin(errorMsg: responseData.message)
                    }
                case 400..<501:
                    self.errorMessage = responseData.message
                    self.errorMessageAlert?()
                default:
                    debugPrint("Unknown Error: Status code \(statusCode)")
                }

            case .failure(let error):
                debugPrint("Request failed with error: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                self.error = error
            }
        }
    }
    
    func fetchInitialHistoryQuestions() {
        isLoading = true
        APIClient.fetchInitialHistoryQuestion { result in
            self.isLoading = false
            switch result {
            case .success(let responseData):
                guard let statusCode = responseData.statuscode else {
                    debugPrint("Unknown Error: Status code is nil")
                    return
                }

                switch statusCode {
                case 200..<300:
                    self.initialHistoryQuestionRes = responseData
                case 401:
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.redirectToLogin(errorMsg: responseData.message)
                    }
                case 400..<501:
                    self.errorMessage = responseData.message
                    self.errorMessageAlert?()
                default:
                    debugPrint("Unknown Error: Status code \(statusCode)")
                }

            case .failure(let error):
                debugPrint("Request failed with error: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                self.error = error
            }
        }
    }
    
    func getHistoryChatQuestions() {
        isLoading = true
        APIClient.fetchHistoryChat { result in
            self.isLoading = false
            switch result {
            case .success(let responseData):
                guard let statusCode = responseData.statuscode else {
                    debugPrint("Unknown Error: Status code is nil")
                    return
                }

                switch statusCode {
                case 200..<300:
                    self.historyChatData = responseData
                case 401:
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.redirectToLogin(errorMsg: responseData.message)
                    }
                case 400..<501:
                    self.errorMessage = responseData.message
                    self.errorMessageAlert?()
                default:
                    debugPrint("Unknown Error: Status code \(statusCode)")
                }

            case .failure(let error):
                debugPrint("Request failed with error: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                self.error = error
            }
        }
    }
}

