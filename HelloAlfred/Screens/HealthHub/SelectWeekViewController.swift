//
//  SelectWeekViewController.swift
//  HelloAlfred
//
//  Created by admin on 03/08/24.
//

import UIKit

class SelectWeekViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    var weekStatuses: WeekStatusModel?
    @IBOutlet var weeksTableViewHeight: NSLayoutConstraint!
    @IBOutlet var weeksTableView: UITableView!
    weak var delegate: WeekViewControllerDelegate?
    var dataToSendBack: String?
    var viewModel = HealthHubViewModel()
    var details : [HealthHubDropDownData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weeksTableView.delegate = self
        weeksTableView.dataSource = self
       // weeksTableViewHeight.constant = CGFloat(90 * weeks.count)
        details = viewModel.dropDownRes?.data ?? []
        weekStatuses = viewModel.weeklyStatusRes
    }
    
    
    // Call this method when you want to dismiss and send data back
    func dismissWithData(selectedData:HealthHubDropDownData, nextWeekQuizKey: String) {
        print("week")
        delegate?.didDismissWithData(selectedData, nextWeekQuizKey: nextWeekQuizKey)
            self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

     @IBAction func backPressed(_ sender: Any) {
         dismiss(animated: true)
     }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeekSelectionTableViewCell") as! WeekSelectionTableViewCell
        cell.weekLabel.text = details[indexPath.row].label
        cell.descriptionLabel.text = details[indexPath.row].title
        let selectedValue = details[indexPath.row].value ?? ""
        if weekStatuses?.isWeekAvailable(selectedValue) == true {
            cell.blurView.isHidden = true
        } else {
            cell.blurView.isHidden = false
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selectedValue = details[indexPath.row].value ?? ""  
        if weekStatuses?.isWeekAvailable(selectedValue) == true {
            if details.count == indexPath.row + 1 {
                dismissWithData(selectedData: details[indexPath.row], nextWeekQuizKey: details[indexPath.row].quizKey ?? "")
                return
            }
            dismissWithData(selectedData: details[indexPath.row], nextWeekQuizKey: details[indexPath.row + 1].quizKey ?? "")
        } else {
            showAlert("Selected week not available")
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
protocol WeekViewControllerDelegate: AnyObject {
    func didDismissWithData(_ data: HealthHubDropDownData, nextWeekQuizKey: String)
}
