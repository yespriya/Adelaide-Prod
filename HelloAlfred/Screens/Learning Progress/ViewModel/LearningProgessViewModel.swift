//
//  LearningProgessViewModel.swift
//  Adelaide Prod
//
//  Created by Prit  on 12/02/26.
//

import SwiftUI
import RxSwift
import UIKit

class LearningProgessViewModel: ObservableObject {

    private let userRepository = UserRepository()
    private let disposeBag = DisposeBag()
    
    @Published var patientAnalyticsData: [PatientAnalyticsData]?
    @Published var weekWiseQuizAnalyticsData: [QuizAnalyticsData]?
    @Published var isError = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var errorMessageAlert: (() -> Void)?
    
    func getLearningProgress(isShowLoader: Bool = true, completion: ((Bool) -> Void)? = nil) {
        self.isLoading = true
        let patientId = UserDefaults.standard.string(forKey: "PateintId") ?? ""

        let model = LearningAnalyticsRequestModel(patient_id: patientId, subdomain: Constants.subdomain)
        userRepository.getLearningProgress(with: model, isShowLoader: isShowLoader)
            .subscribe(onSuccess: { [weak self] response in
                if response.status ?? false == false {
                    if response.statuscode == 401 {
                        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                            appDelegate.redirectToLogin(errorMsg: response.message)
                        }
                    }
                    self?.errorMessage = response.message
                    self?.isError = true
                    self?.errorMessageAlert?()
                    self?.isLoading = false
                    completion?(false)
                } else {
                    self?.patientAnalyticsData = response.data
                    self?.isLoading = false
                    completion?(true)
                }
            }, onFailure: { [weak self] error in
                self?.errorMessage = error.localizedDescription
                self?.isError = true
                self?.errorMessageAlert?()
                self?.isLoading = false
                completion?(false)
            })
            .disposed(by: disposeBag)
    }
    
    func getWeekWiseQuizAnalytics(weekKey: String, isShowLoader: Bool = true, completion: ((Bool) -> Void)? = nil) {
        self.isLoading = true
        let patientId = UserDefaults.standard.string(forKey: "PateintId") ?? ""

        let model = WeekWiseQuizAnalyticsRequestModel(patient_id: patientId, week_key: weekKey)
        userRepository.getWeekWiseQuizAnalytics(with: model, isShowLoader: isShowLoader)
            .subscribe(onSuccess: { [weak self] response in
                if response.status ?? false == false {
                    if response.statuscode == 401 {
                        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                            appDelegate.redirectToLogin(errorMsg: response.message)
                        }
                    }
                    self?.errorMessage = response.message
                    self?.isError = true
                    self?.errorMessageAlert?()
                    self?.isLoading = false
                    completion?(false)
                } else {
                    self?.weekWiseQuizAnalyticsData = response.data
                    self?.isLoading = false
                    completion?(true)
                }
            }, onFailure: { [weak self] error in
                self?.errorMessage = error.localizedDescription
                self?.isError = true
                self?.errorMessageAlert?()
                self?.isLoading = false
                completion?(false)
            })
            .disposed(by: disposeBag)
    }
}
