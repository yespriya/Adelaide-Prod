//
//  ChatViewModel.swift
//  HeloAlfredbotservice
//
//  Created by admin on 2/9/24.
//

import Foundation

class ChatViewModel {
    // Properties
    
    var chatFetchStatus:ChatModel? {
        didSet {
            self.chatFetchSuccessfully?()
        }
    }
    
    var error:Error? {
        didSet {
            self.errorMessageAlert?()
        }
    }
    var errorMessage:String?
    var isLoading: Bool = false {
        didSet {
            self.loadingStatus?()
        }
    }
    
    // Closures for callback
    var chatFetchSuccessfully:(() -> ())?
    var loadingStatus:(() -> ())?
    
    var errorMessageAlert:(() -> ())?
    
    func updateMessgaesToAI(params:Dictionary<String,Any>) {
        isLoading = true
        APIClient.updateMessgaesToAI(params: params) { result in
            switch result {
            case .success(let responseData):
                self.isLoading = false
                if responseData.choices != nil {
                    do {
                        self.chatFetchStatus = responseData
                    }
                } else {
                    self.errorMessage = "Can't Fetch status"
                    self.errorMessageAlert?()
                }
                
            case .failure(let error):
                debugPrint(error.localizedDescription)
                self.errorMessage = error.localizedDescription
                self.error = error
                self.isLoading = false
            }
        }
    }
}
