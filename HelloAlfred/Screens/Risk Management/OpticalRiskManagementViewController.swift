//
//  OpticalRiskManagementViewController.swift
//  HelloAlfred
//
//  Created by admin on 20/05/24.
//

import UIKit

class OpticalRiskManagementViewController: UIViewController {
    @IBOutlet var riskDetailsTableView: UITableView!
    let viewModel = DashboardViewModel()

    @IBOutlet var titleLabel: UILabel!
    var riskImages = ["risk-management-image1","risk-management-image2","risk-management-image3"]
    override func viewDidLoad() {
        super.viewDidLoad()
        riskDetailsTableView.delegate = self
        riskDetailsTableView.dataSource = self
        riskDetailsTableView.register(UINib(nibName: "RiskManagementParentTableViewCell", bundle: .main), forCellReuseIdentifier: "RiskManagementParentTableViewCell")
       titleLabel.attributedText = customizeInitialLetter(categoryText: titleLabel.text!)
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        
        print("ddoonnee")
        updateUserStatusApiCall()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    func updateUserStatusApiCall()
    {
        let params: [String: Any] = [
            "optimal_risk_managemment": 1,
        ]
        viewModel.updateUserDetails(params: params)
        viewModel.statusUpdateSuccess = {
            
            
            self.navigateTo(viewController: DashboardViewController.self, withIdentifier: "DashboardViewController")
        }
        viewModel.loadingStatus =
        {
            if self.viewModel.isLoading {
                self.activityIndicator(self.view, startAnimate: true)
            } else {
                self.activityIndicator(self.view, startAnimate: false)
            }
        }
        viewModel.errorMessageAlert = {
            self.showAlert(self.viewModel.errorMessage ?? "Error")
        }
    }

}
extension OpticalRiskManagementViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return riskImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RiskManagementParentTableViewCell") as! RiskManagementParentTableViewCell
        cell.sectionNumber = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if let cell = tableView.cellForRow(at: indexPath) as? RiskManagementParentTableViewCell {
                cell.flipCell() // Trigger the flip animation
            }
        }
}
