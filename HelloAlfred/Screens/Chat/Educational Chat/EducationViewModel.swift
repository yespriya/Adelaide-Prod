//
//  EducationViewModel.swift
//  HelloAlfred
//
//  Created by SS on 15/10/25.
//

import Foundation
import Alamofire
import UIKit

class EducationChatViewModel {
    // Properties
    var staticMessageRes: ChatStaticMessageModel? {
        didSet {
            self.getStaticMessageResSuccess?()
        }
    }
    
    var preferenceChatRes: ChatPreferenceModel? {
        didSet {
            self.getPreferenceChatResSuccess?()
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
    var getStaticMessageResSuccess: (() -> Void)?
    var getPreferenceChatResSuccess: (() -> Void)?
    var loadingStatus: (() -> Void)?
    var errorMessageAlert: (() -> Void)?
    
    // Fetch Static Message
    func fetchStaticMessage() {
        isLoading = true
        
        APIClient.fetchBotStaticMessage { result in
            self.isLoading = false
            
            switch result {
            case .success(let responseData):
                guard let statusCode = responseData.statuscode else {
                    self.errorMessage = "Unknown Error: Status code is nil"
                    self.error = self.error
                    return
                }
                
                switch statusCode {
                case 200..<300:
                    self.staticMessageRes = responseData
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
    func preferenceChat(params: [String: Any]) {
        isLoading = true
        APIClient.preferenceChat(params: params) { result in
            switch result {
            case .success(let responseData):
                guard let statusCode = responseData.statuscode else {
                    self.errorMessage = "Unknown Error: Status code is nil"
                    self.error = self.error
                    return
                }
                
                switch statusCode {
                case 200..<300:
                    self.preferenceChatRes = responseData
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
    

    func  sendPostRequest(message: String, sessionID: String) {
        
        let url = "https://adelaide-stream.helloalfred.ai/bots/knowledge-bot/v1/ask/stream"
        
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        if let token = UserDefaults.standard.string(forKey: "Authorization"), !token.isEmpty {
            headers.add(name: "Authorization", value: token)
        }


        AF.request(
            url,
            method: .post,
            parameters: ["message": message,"session_id": sessionID],
            encoding: JSONEncoding.default,
            headers: headers
        )
        .responseData { response in

            switch response.result {
            case .success(let data):
                let responseString = String(data: data, encoding: .utf8) ?? ""
                print("✅ Response:", responseString)
                self.saveChat(params: [
                    "session_id": sessionID,
                    "alfred": responseString,
                    "user": message,
                    "refference": [:]
                ])
            case .failure(let error):
                print("❌ API Error:", error.localizedDescription)
            }
        }
    }
    
    func saveChat(params: [String: Any]) {
        
        let url = "https://adelaide-stream.helloalfred.ai/educational-bot-answer-dump"
        
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        if let token = UserDefaults.standard.string(forKey: "Authorization"), !token.isEmpty {
            headers.add(name: "Authorization", value: token)
        }


        AF.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .responseData { response in

            switch response.result {
            case .success(let data):
                let responseString = String(data: data, encoding: .utf8) ?? ""
                print("✅ Response:", responseString)

            case .failure(let error):
                print("❌ API Error:", error.localizedDescription)
            }
        }
    }

}
