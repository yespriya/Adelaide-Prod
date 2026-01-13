//
//  LastUpdatedViewController.swift
//  HelloAlfred
//
//  Created by admin on 10/09/24.
//

import UIKit

class LastUpdatedDetailsViewController: UIViewController{
    
    
    @IBOutlet var detailsTableViewHeightConstraint: NSLayoutConstraint!
    var fromListOfSymptoms = false
    
    @IBOutlet var bgViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var bgViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var bgViewWidthContraint: NSLayoutConstraint!
    @IBOutlet var bgViewBottomContraint: NSLayoutConstraint!
    @IBOutlet var bgViewVerticalConstraint: NSLayoutConstraint!
    let healthViewModel = HealthDetailsViewModel()
    let symptomsViewModel = SymptomsViewModel()
    var symptomsDetails = [SymptomsDetailsData]()
    @IBOutlet var detailsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        fetchData()
        updateUI()
       // detailsTableViewHeightConstraint.constant = CGFloat(50 * (fromListOfSymptoms ? 5 : 1))

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: false)
    }
    
    func fetchData()
    {
        if(fromListOfSymptoms)
        {
            fetchLatestSymptomsData()
        }
        else
        {
            fetchLatestExpertMonitoringData()
        }
    }
    func updateUI()
    {
        if(fromListOfSymptoms)
        {
            bgViewBottomContraint.isActive = true
            bgViewVerticalConstraint.isActive = false
            detailsTableViewHeightConstraint.constant = 600
            bgViewLeadingConstraint.constant = 0
            bgViewTrailingConstraint.constant = 0
        }
        else
        {
            bgViewBottomContraint.isActive = false
            bgViewVerticalConstraint.isActive = true
            detailsTableViewHeightConstraint.constant = 190
            bgViewLeadingConstraint.constant = 24
            bgViewTrailingConstraint.constant = 24
        }
    }
    
    func fetchLatestSymptomsData()
    {
        symptomsViewModel.fetchLastUpdatedListofSymptomsDetails()
        symptomsViewModel.LastUpdateSymptomsDetailsFetchSuccess = {
            self.symptomsDetails = self.symptomsViewModel.latestSymptomsDetailRes?.data ?? []
            self.detailsTableView.reloadData()
        }
        symptomsViewModel.loadingStatus =
        {
            if self.symptomsViewModel.isLoading {
                self.activityIndicator(self.view, startAnimate: true)
            } else {
                self.activityIndicator(self.view, startAnimate: false)
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
        symptomsViewModel.errorMessageAlert = {
            self.showAlert(self.symptomsViewModel.errorMessage ?? "Error")
           
        }
    }
    
    func fetchLatestExpertMonitoringData()
    {
        healthViewModel.fetchLastUpdateExpertMonitoringDetail()
        healthViewModel.lastUpdatedExpertMonitoringDataFetchSuccess = {
            self.detailsTableView.reloadData()
        }
        healthViewModel.loadingStatus =
        {
            if self.healthViewModel.isLoading {
                self.activityIndicator(self.view, startAnimate: true)
            } else {
                self.activityIndicator(self.view, startAnimate: false)
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
        healthViewModel.errorMessageAlert = {
            self.showAlert(self.healthViewModel.errorMessage ?? "Error")
           
        }
    }
}
extension LastUpdatedDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fromListOfSymptoms ? symptomsDetails.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = detailsTableView.dequeueReusableCell(withIdentifier: "LastUpdatedDetailsTableViewCell") as! LastUpdatedDetailsTableViewCell
        if(fromListOfSymptoms)
        {
            cell.details4Label.isHidden = false
            cell.details1Label.text = symptomsDetails[indexPath.row].symptoms_key
            cell.details2Label.text = symptomsDetails[indexPath.row].frequency
            cell.details3Label.text = symptomsDetails[indexPath.row].severity
            cell.details4Label.text = symptomsDetails[indexPath.row].quality_of_life
            
            cell.title1Label.text = "Symptom"
            cell.title2Label.text = "Frequency"
            cell.title3Label.text = "Severity"
            cell.title4Label.text = "Effecting quality of life"
            cell.title4Label.isHidden = false
            
            cell.bgView.layer.shadowRadius = 5
            cell.bgView.layer.shadowOpacity = 0.4
            cell.bgView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.bgView.layer.shadowColor = UIColor.gray.cgColor
            cell.bgView.layer.cornerRadius = 12
            cell.bgView.layer.masksToBounds = false
        }
        else
        {
            let data = healthViewModel.lastUpdateExpertMonitoringRes?.data
            cell.details1Label.text = data?.weight
            cell.details2Label.text = data?.bloodp
            cell.details3Label.text = data?.pulse
            cell.details4Label.isHidden = true
            
            cell.title1Label.text = "Weight"
            cell.title2Label.text = "Blood Pressure"
            cell.title3Label.text = "Pulse"
            cell.title4Label.isHidden = true

        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}
