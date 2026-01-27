import Foundation
import UIKit
import Alamofire

class HealthHubViewModel {
    // Properties
    var weeklyContentRes: WeeklyContentModel? {
        didSet {
            self.weeklyContentFetchSuccess?()
        }
    }
    
    var healthHubUpdateStatusRes: HealthHubStatusResponse? {
        didSet {
            self.healthHubStatusUpdateSuccess?()
        }
    }
    var weeklyStatusRes: WeekStatusModel? {
        didSet {
            self.weeklyStatusFetchSuccess?()
        }
    }
    
    var dropDownRes: HealthHubDropDownModel? {
        didSet {
            self.dropDownFetchSuccess?()
        }
    }
    var overviewRes: HealthHubOverviewModel? {
        didSet {
            self.overviewFetchSuccess?()
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
    var weeklyContentFetchSuccess: (() -> Void)?
    var healthHubStatusUpdateSuccess: (() -> Void)?
    var weeklyStatusFetchSuccess: (() -> Void)?
    var dropDownFetchSuccess: (() -> Void)?
    var overviewFetchSuccess: (() -> Void)?
    var loadingStatus: (() -> Void)?
    var errorMessageAlert: (() -> Void)?
    
    // Fetch Weekly Content
    func fetchWeeklyContent(params: String) {
        isLoading = true
        
        APIClient.fetchWeeklyContent(params: params) { result in
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
                    self.weeklyContentRes = responseData
                    print(responseData)
                    self.weeklyContentFetchSuccess?()
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
    
    // Fetch Week Status
    func fetchWeekStatus() {
        isLoading = true
        
        APIClient.fetchWeekStatus { result in
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
                    self.weeklyStatusRes = responseData
                    self.weeklyStatusFetchSuccess?()
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
    
    func fetchHealthHubDropDownData() {
        isLoading = true
        
        APIClient.fetchHealthHubDropDownData(params: ["subdomain": "api.adelaide.helloalfred.ai"]) { result in
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
                    self.dropDownRes = responseData
                    print("DropDown ---------------> \(responseData)")
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
    
    func fetchHealthHubOverviewData() {
        isLoading = true
        
        APIClient.fetechHealthHubOverview(params: ["subdomain":"api.adelaide.helloalfred.ai"]) { result in
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
                    self.overviewRes = responseData
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
    
    func updateHealthHubStatus(params: [String: Any]) {
        isLoading = true
        APIClient.updateHealthHubStatus(params: params) { result in
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
                    self.healthHubUpdateStatusRes = responseData
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
    
    func getLatestUnlockedModule() -> HealthHubDropDownData? {
        guard let weekStatus = weeklyStatusRes?.data, let dropDownData = dropDownRes?.data else {
            return nil
        }
        
        // Filter unlocked weeks (true values)
        let unlockedWeeks = weekStatus.filter { $0.value == true }.keys
        
        // Find max week number
        var maxWeekNum = -1
        var maxWeekKey = ""
        
        for key in unlockedWeeks {
            // Extract number from "weekX"
            let weekNumString = key.replacingOccurrences(of: "week", with: "")
            if let weekNum = Int(weekNumString) {
                if weekNum > maxWeekNum {
                    maxWeekNum = weekNum
                    maxWeekKey = key
                }
            }
        }
        
        guard !maxWeekKey.isEmpty else { return nil }
        
        // Find corresponding drop down data
        return dropDownData.first(where: { $0.value == maxWeekKey })
    }
}

