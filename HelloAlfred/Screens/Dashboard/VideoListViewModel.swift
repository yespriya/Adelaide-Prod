//
//  VideoListViewModel.swift
//  HelloAlfred
//
//  Created by MAC on 12/6/24.
//

import Foundation
import Alamofire
import UIKit

class VideoListViewModel {
    // Properties
    var videoContentRes: VideoListContentModel? {
        didSet {
            debugPrint("videoContentRes updated: \(String(describing: videoContentRes))")
            self.videoContentFetchSuccess?()
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
    var videoContentFetchSuccess: (() -> Void)?

    var loadingStatus: (() -> Void)?
    var errorMessageAlert: (() -> Void)?
    
    
    func fetchVideoContent() {
        isLoading = true
        APIClient.fetchVideoContent { result in
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
                    self.videoContentRes = responseData
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

