//
//  LifeStyleGoalDetailsViewController.swift
//  HelloAlfred
//
//  Created by admin on 09/04/24.
//

import UIKit

class LifeStyleGoalDetailsViewController: UIViewController {

    @IBOutlet var lifeStyleLabel: UILabel!
    @IBOutlet var stepsView: Myview!
    @IBOutlet var exerciseView: Myview!
    @IBOutlet var medicationView: Myview!
    @IBOutlet var sleepView: Myview!
    @IBOutlet var calorieView: Myview!
    let dashboardViewModel = DashboardViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    func updateUI()
    {
        lifeStyleLabel.attributedText = customizeInitialLetter(categoryText: lifeStyleLabel.text!)

        
        stepsView.layer.shadowRadius = 10
        stepsView.layer.shadowOpacity = 0.6
        stepsView.layer.shadowOffset = CGSize(width: 3, height: 1)
        stepsView.layer.shadowColor = UIColor.gray.cgColor
        stepsView.layer.masksToBounds = false
        
        
        calorieView.layer.shadowRadius = 5
        calorieView.layer.shadowOpacity = 0.6
        calorieView.layer.shadowOffset = CGSize(width: 3, height: 1)
        calorieView.layer.shadowColor = UIColor.gray.cgColor
        calorieView.layer.masksToBounds = false
        
        sleepView.layer.shadowRadius = 5
        sleepView.layer.shadowOpacity = 0.6
        sleepView.layer.shadowOffset = CGSize(width: 3, height: 1)
        sleepView.layer.shadowColor = UIColor.gray.cgColor
        sleepView.layer.masksToBounds = false
        
        medicationView.layer.shadowRadius = 5
        medicationView.layer.shadowOpacity = 0.6
        medicationView.layer.shadowOffset = CGSize(width: 3, height: 1)
        medicationView.layer.shadowColor = UIColor.gray.cgColor
        medicationView.layer.masksToBounds = false
        
        exerciseView.layer.shadowRadius = 5
        exerciseView.layer.shadowOpacity = 0.6
        exerciseView.layer.shadowOffset = CGSize(width: 3, height: 1)
        exerciseView.layer.shadowColor = UIColor.gray.cgColor
        exerciseView.layer.masksToBounds = false
    }

    @IBAction func cancelPressed(_ sender: Any) {
        navigateTo(viewController: DashboardViewController.self, withIdentifier: "DashboardViewController")
    }
    @IBAction func backPressed(_ sender: Any) 
    {
        navigateTo(viewController: SetTimePeriodViewController.self, withIdentifier: "SetTimePeriodViewController")
    }
    
    @IBAction func editPressed(_ sender: Any) {
        navigateTo(viewController: LifeStyleCategoryViewController.self, withIdentifier: "LifeStyleCategoryViewController")
    }
    
    @IBAction func proceedClicked(_ sender: Any) {
        self.updateUserStatusApiCall()
    }
    
    func updateUserStatusApiCall()
    {
        let params: [String: Any] = [
            "lifestyle_goals": 1,
        ]
        dashboardViewModel.updateUserDetails(params: params)
        dashboardViewModel.statusUpdateSuccess = {
           
            self.navigateTo(viewController: DashboardViewController.self, withIdentifier: "DashboardViewController")
        }
        dashboardViewModel.loadingStatus =
        {
            if self.dashboardViewModel.isLoading {
                self.activityIndicator(self.view, startAnimate: true)
            } else {
                self.activityIndicator(self.view, startAnimate: false)
            }
        }
        dashboardViewModel.errorMessageAlert = {
            self.showAlert(self.dashboardViewModel.errorMessage ?? "Error")
        }
    }
    
}
