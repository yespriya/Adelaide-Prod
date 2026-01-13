import Foundation
import UIKit
import Alamofire
class HealthDetailsViewModel {
    //Properties
     
    var updateHealthDetailsRes:CommonResModel?{
       didSet
       {
           self.healthDetailsUpdateSuccess?()
       }
   }
    var lastUpdateHealthRes:LastUpdateHealthDetailsModel?{
       didSet
       {
           self.lastUpdateHealthDetailsFetchSuccess?()
       }
   }
    
    var lastUpdateExpertMonitoringRes:LastestExpertMonitoringModel?{
       didSet
       {
           self.lastUpdatedExpertMonitoringDataFetchSuccess?()
       }
   }
    var LinearChartDataRes:LinearChartDataModel?{
       didSet
       {
           self.LinearChartDataFetchSuccess?()
       }
   }

    var error:Error?{
        didSet{self.errorMessageAlert?()}
    }
    var errorMessage:String?
    
    var isLoading: Bool = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.loadingStatus?()
            }
        }
    }

    
    //Closures for callback
    var healthDetailsUpdateSuccess:(() -> ())?
    var lastUpdateHealthDetailsFetchSuccess:(() -> ())?
    var LinearChartDataFetchSuccess:(() -> ())?
    var lastUpdatedExpertMonitoringDataFetchSuccess:(() -> ())?




    var loadingStatus:(() -> ())?
    var errorMessageAlert:(() -> ())?
    
    func updateHealthDetails(params: Dictionary<String, Any>) 
    {
        isLoading = true
        APIClient.updateHealthDetails(params: params) { result in
            debugPrint("Response data \(result)")
            switch result {
            case .success(let responseData):
                self.isLoading = false
                switch responseData.statuscode ?? 500 {
                case 200..<300:
                    self.updateHealthDetailsRes = responseData
                case 401:
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                            appDelegate.redirectToLogin(errorMsg: responseData.message)
                        }
                case 402..<501:
                    self.errorMessage = responseData.message
                    self.errorMessageAlert?()
                default:
                    debugPrint("Unknown Error")
                }
            case .failure(let error):
                debugPrint(error.localizedDescription)
                self.errorMessage = error.localizedDescription
                self.error = error
                self.isLoading = false
            }
        }
    }
    
    
    
    func fetchLastUpdateHealthDetail()
    {
        isLoading = false
        APIClient.lastUpdateHealthDetails() { result in
            debugPrint("Response data \(result)")
            switch result {
            case .success(let responseData):
                self.isLoading = false
                switch responseData.statuscode ?? 500 {
                case 200..<300:
                    self.lastUpdateHealthRes = responseData
                case 401:
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                            appDelegate.redirectToLogin(errorMsg: responseData.message)
                        }
                case 402..<501:
                    self.errorMessage = responseData.message
                    self.errorMessageAlert?()
                default:
                    debugPrint("Unknown Error")
                }
            case .failure(let error):
                debugPrint(error.localizedDescription)
                self.errorMessage = error.localizedDescription
                self.error = error
                self.isLoading = false
            }
        }
    }
    
    func fetchLastUpdateExpertMonitoringDetail()
    {
        isLoading = true
        APIClient.lastUpdatedExpertMonitoringDetails { result in
            debugPrint("Response data \(result)")
            switch result {
            case .success(let responseData):
                self.isLoading = false
                switch responseData.statuscode ?? 500 {
                case 200..<300:
                    self.lastUpdateExpertMonitoringRes = responseData
                case 401:
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                            appDelegate.redirectToLogin(errorMsg: responseData.message)
                        }
                case 402..<501:
                    self.errorMessage = responseData.message
                    self.errorMessageAlert?()
                default:
                    debugPrint("Unknown Error")
                }
            case .failure(let error):
                debugPrint(error.localizedDescription)
                self.errorMessage = error.localizedDescription
                self.error = error
                self.isLoading = false
            }
        }
    }
    
    func fetchLinearChartData(params: Dictionary<String, Any>)
    {
        isLoading = true
        APIClient.fetchLinearChartData(params: params) { result in
            debugPrint("Response data \(result)")
            switch result {
            case .success(let responseData):
                self.isLoading = false
                switch responseData.statuscode ?? 500 {
                case 200..<300:
                    self.LinearChartDataRes = responseData
                case 401:
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                            appDelegate.redirectToLogin(errorMsg: responseData.message)
                        }
                case 402..<501:
                    self.errorMessage = responseData.message
                    self.errorMessageAlert?()
                default:
                    debugPrint("Unknown Error")
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

