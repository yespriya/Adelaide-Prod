import Foundation
import UIKit
import Alamofire

class HistoryTranscriptViewModel {
    // Properties
    var historyTranscriptRes: HistoryTranscriptModel?
    var error: Error?
    var errorMessage: String?
    
    var isLoading: Bool = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.loadingStatus?()
            }
        }
    }

    
    // Closures for callback
    var historyTranscriptFetchSuccess: (() -> Void)?
    var loadingStatus: (() -> Void)?
    var errorMessageAlert: (() -> Void)?
    
    // Fetch History Transcript
    func fetchHistoryTranscript() {
        isLoading = true
        APIClient.fetchHistoryTranscript { result in
            self.isLoading = false

            switch result {
            case .success(let responseData):
                guard let statusCode = responseData.statuscode else {
                    debugPrint("Unknown Error: Status code is nil")
                    return
                }

                switch statusCode {
                case 200..<300:
                    self.historyTranscriptRes = responseData
                    self.historyTranscriptFetchSuccess?()
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

