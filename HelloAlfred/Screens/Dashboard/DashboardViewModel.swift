import Foundation
import UIKit
import Alamofire

class DashboardViewModel {
    // Properties
    var userStatusRes: UserStatusModel?
    var userStatusUpdateRes: CommonResModel?
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
    var userStatusFetchSuccess: (() -> Void)?
    var statusUpdateSuccess: (() -> Void)?
    var loadingStatus: (() -> Void)?
    var errorMessageAlert: (() -> Void)?
    
    // Fetch User Status Details
    func fetchUserStatusDetails() {
        isLoading = true
        APIClient.fetchUserStatus { result in
            self.isLoading = false

            switch result {
            case .success(let responseData):
                guard let statusCode = responseData.statuscode else {
                    self.errorMessage = "Invalid Status Code"
                    self.errorMessageAlert?()
                    return
                }

                switch statusCode {
                case 200..<300:
                    self.userStatusRes = responseData
                    self.userStatusFetchSuccess?()
                case 401:
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.redirectToLogin(errorMsg: responseData.message)
                    }
                case 400..<500:
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
    
    // Update User Details
    func updateUserDetails(params: [String: Any]) {
        isLoading = true
        APIClient.updateUserStatus(params: params) { result in
            self.isLoading = false

            switch result {
            case .success(let responseData):
                guard let statusCode = responseData.statuscode else {
                    self.errorMessage = "Invalid Status Code"
                    self.errorMessageAlert?()
                    return
                }

                switch statusCode {
                case 200..<300:
                    self.userStatusUpdateRes = responseData
                    self.statusUpdateSuccess?()
                case 401:
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.redirectToLogin(errorMsg: responseData.message)
                    }
                case 400..<500:
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

