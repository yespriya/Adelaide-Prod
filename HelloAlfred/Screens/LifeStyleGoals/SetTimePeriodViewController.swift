//
//  SetTimePeriodViewController.swift
//  HelloAlfred
//
//  Created by admin on 05/04/24.
//

import UIKit

class SetTimePeriodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var timePeriod = ["1 Week","15 Days","1 Month"]
    @IBOutlet var goalPeriodTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        goalPeriodTableView.delegate = self
        goalPeriodTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timePeriod.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalTimePeriodTableViewCell") as! GoalTimePeriodTableViewCell
        cell.periodLabel.text = timePeriod[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        navigateTo(viewController: GoalCreationSuccessViewController.self, withIdentifier: "GoalCreationSuccessViewController")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    

}
