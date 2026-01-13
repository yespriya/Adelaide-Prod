import Foundation
import UIKit
import Alamofire

class ProfileViewModel {
    // Properties
    var profileDetailsRes: ProfileDetailsModel? {
        didSet {
            self.profileFetchSuccess?()
        }
    }

    var profileCompletionRes: ProfileCompletionModel? {
        didSet {
            self.profileCompletionFetchSuccess?()
        }
    }

    var userUpdateRes: CommonResModel? {
        didSet {
            self.profileUpdateSuccess?()
        }
    }
    var profileImageDeleteRes: CommonResModel? {
        didSet {
            self.profileImageDeleteSuccess?()
        }
    }
    var error: Error? {
        didSet {
            self.errorMessageAlert?()
        }
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
    var profileFetchSuccess: (() -> Void)?
    var profileCompletionFetchSuccess: (() -> Void)?
    var profileUpdateSuccess: (() -> Void)?
    var profileImageDeleteSuccess: (() -> Void)?

    var loadingStatus: (() -> Void)?
    var errorMessageAlert: (() -> Void)?

    // Fetch User Details
    func fetchUserDetails() {
        isLoading = true

        APIClient.fetchUserDetails { result in
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
                    self.profileDetailsRes = responseData
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

    // Fetch Profile Completion Status
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

    // Update User Details
    func updateUserDetails(params: [String: Any]) {
        isLoading = true

        APIClient.updateUser(params: params) { result in
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
                    self.userUpdateRes = responseData
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
    
    // Delete Profile Image
    func deleteProfileImage() {
        isLoading = true

        APIClient.deleteProfileImage { result in
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
                    self.profileImageDeleteRes = responseData
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

