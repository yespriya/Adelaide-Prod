import Foundation
import UIKit
import Alamofire

class AuthViewModel {
    // Properties
    var signupRes: CommonResModel?
    var generateOTPRes: CommonResModel?
    var verifyOTPRes: CommonResModel?
    var updatePasswordRes: CommonResModel?
    var changePasswordRes: CommonResModel?
    var sendTNCRes: CommonResModel?

    var termsAndConditionsRes: TermsAndConditionsModel?

    var signInData: SigninResModel?
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
    var registerSuccess: (() -> Void)?
    var generateOTPSuccess: (() -> Void)?
    var verifyOTPSuccess: (() -> Void)?
    var updatePasswordSuccess: (() -> Void)?
    var changePasswordSuccess: (() -> Void)?
    var fetchTermsAndContionsSuccess: (() -> Void)?
    var sendTNCSuccess: (() -> Void)?


    var signInSuccess: (() -> Void)?
    var loadingStatus: (() -> Void)?
    var errorMessageAlert: (() -> Void)?

    // Signup User
    func signupUser(params: [String: Any]) {
        isLoading = true
        APIClient.signupUser(params: params) { result in
            self.isLoading = false

            switch result {
            case .success(let responseData):
                guard let statusCode = responseData.statuscode else {
                    debugPrint("Unknown Error: Status code is nil")
                    return
                }

                switch statusCode {
                case 200..<300:
                    self.signupRes = responseData
                    self.registerSuccess?()
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

    // Signin User
    func signinUser(params: [String: Any]) {
        isLoading = true
        APIClient.signInUser(params: params) { result in
            self.isLoading = false

            switch result {
            case .success(let responseData):
                guard let statusCode = responseData.statuscode else {
                    debugPrint("Unknown Error: Status code is nil")
                    return
                }

                switch statusCode {
                case 200..<300:
                    self.signInData = responseData
                    self.signInSuccess?()
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

    // Generate OTP
    func generateOTP(params: [String: Any]) {
        isLoading = true
        print(params)
        APIClient.generateOTP(params: params) { result in
            self.isLoading = false
            
            switch result {
            case .success(let responseData):
                guard let statusCode = responseData.statuscode else {
                    debugPrint("Unknown Error: Status code is nil")
                    return
                }
                print(responseData.message)
                print((responseData.dictionaryFromObject ?? [:]) as [String: Any])
                print(statusCode)
                switch statusCode {
                case 200..<300:
                    self.generateOTPRes = responseData
                    self.generateOTPSuccess?()
                case 400..<501:
//                    self.errorMessage = responseData.message
//                    self.errorMessageAlert?()
                    self.generateOTPRes = responseData
                    self.generateOTPSuccess?()
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

    // Verify OTP
    func verifyOTP(params: [String: Any]) {
        isLoading = true
        APIClient.verifyOTP(params: params) { result in
            self.isLoading = false

            switch result {
            case .success(let responseData):
                guard let statusCode = responseData.statuscode else {
                    debugPrint("Unknown Error: Status code is nil")
                    return
                }

                switch statusCode {
                case 200..<301:
                    self.verifyOTPRes = responseData
                    self.verifyOTPSuccess?()
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

    // Update Password
    func updatePassword(params: [String: Any]) {
        isLoading = true
        APIClient.updatePassword(params: params) { result in
            self.isLoading = false

            switch result {
            case .success(let responseData):
                guard let statusCode = responseData.statuscode else {
                    debugPrint("Unknown Error: Status code is nil")
                    return
                }

                switch statusCode {
                case 200..<300:
                    self.updatePasswordRes = responseData
                    self.updatePasswordSuccess?()
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

    // Change Password
    func changePassword(params: [String: Any]) {
        isLoading = true
        APIClient.changePassword(params: params) { result in
            self.isLoading = false

            switch result {
            case .success(let responseData):
                guard let statusCode = responseData.statuscode else {
                    debugPrint("Unknown Error: Status code is nil")
                    return
                }

                switch statusCode {
                case 200..<300:
                    self.changePasswordRes = responseData
                    self.changePasswordSuccess?()
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

    // Google Auth
    func googleAuth(params: [String: Any]) {
        isLoading = true
        APIClient.googleAuth(params: params) { result in
            self.isLoading = false

            switch result {
            case .success(let responseData):
                guard let statusCode = responseData.statuscode else {
                    debugPrint("Unknown Error: Status code is nil")
                    return
                }

                switch statusCode {
                case 200..<300:
                    self.signInData = responseData
                    self.signInSuccess?()
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
    
    func fetchTermsAndConditions() {
        isLoading = true
        APIClient.fetchTermsAndConditions { result in
            self.isLoading = false
            switch result {
            case .success(let responseData):
                guard let statusCode = responseData.statuscode else {
                    debugPrint("Unknown Error: Status code is nil")
                    return
                }

                switch statusCode {
                case 200..<300:
                    self.termsAndConditionsRes = responseData
                    self.fetchTermsAndContionsSuccess?()
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
    
    func sendTNC(params: [String: Any]) {
        isLoading = true
        APIClient.sendTNC(params: params) { result in
            self.isLoading = false

            switch result {
            case .success(let responseData):
                guard let statusCode = responseData.statuscode else {
                    debugPrint("Unknown Error: Status code is nil")
                    return
                }

                switch statusCode {
                case 200..<300:
                    self.sendTNCRes = responseData
                    self.sendTNCSuccess?()
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

