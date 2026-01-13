import Foundation
import UIKit
import Alamofire
class SymptomsViewModel {
    //Properties
     
    var addSymptomsRes:CommonResModel?{
       didSet
       {
           self.symptomsUpdateSuccess?()
       }
   }
     var lastUpdateSymptomsRes:LastUpdateHealthDetailsModel?{
        didSet
        {
            self.lastUpdateSymptomsFetchSuccess?()
        }
    }
    var latestSymptomsDetailRes:LastestSymptomsDetailsModel?{
       didSet
       {
           self.LastUpdateSymptomsDetailsFetchSuccess?()
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
    var symptomsUpdateSuccess:(() -> ())?
    var lastUpdateSymptomsFetchSuccess:(() -> ())?
    var LastUpdateSymptomsDetailsFetchSuccess:(() -> ())?



    var loadingStatus:(() -> ())?
    var errorMessageAlert:(() -> ())?
    
    func addSymptoms(params: Dictionary<String, Any>) {
        isLoading = true
        APIClient.addSymptoms(params: params) { result in
            debugPrint("Response data \(result)")
            switch result {
            case .success(let responseData):
                self.isLoading = false
                switch responseData.statuscode ?? 500 {
                case 200..<300:
                    if let jsonData = try? JSONEncoder().encode(responseData) {
                        let decoder = JSONDecoder()
                        do {
                            self.addSymptomsRes = try decoder.decode(CommonResModel.self, from: jsonData)
                        } catch {
                            debugPrint(error.localizedDescription)
                        }
                    } else {
                        self.errorMessage = responseData.message
                        self.errorMessageAlert?()
                    }
                case 401:
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                            appDelegate.redirectToLogin(errorMsg: responseData.message)
                        }
                case 400..<501:
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
    
    func fetchLastUpdateListofSymptoms()
    {
        isLoading = true
        APIClient.lastUpdateListofSymptoms{ result in
            debugPrint("Response data \(result)")
            switch result {
            case .success(let responseData):
                self.isLoading = false
                switch responseData.statuscode ?? 500 {
                case 200..<300:
                    if let jsonData = try? JSONEncoder().encode(responseData) {
                        let decoder = JSONDecoder()
                        do {
                            self.lastUpdateSymptomsRes = try decoder.decode(LastUpdateHealthDetailsModel.self, from: jsonData)
                        } catch {
                            debugPrint(error.localizedDescription)
                        }
                    } else {
                        self.errorMessage = responseData.message
                        self.errorMessageAlert?()
                    }
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
                self.errorMessageAlert?()
                self.error = error
                self.isLoading = false
            }
        }
    }
    func fetchLastUpdatedListofSymptomsDetails()
    {
        isLoading = true
        APIClient.lastUpdatedSymptomsDetails{ result in
            debugPrint("Res \(result)")
            switch result {
            case .success(let responseData):
                self.isLoading = false
                switch responseData.statuscode ?? 500 {
                case 200..<300:
                    if let jsonData = try? JSONEncoder().encode(responseData) {
                        let decoder = JSONDecoder()
                        do {
                            self.latestSymptomsDetailRes = try decoder.decode(LastestSymptomsDetailsModel.self, from: jsonData)
                        } catch {
                            debugPrint(error.localizedDescription)
                        }
                    } else {
                        self.errorMessage = responseData.message
                        self.errorMessageAlert?()
                    }
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
