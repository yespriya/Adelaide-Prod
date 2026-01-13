//
//  TestViewController.swift
//  HelloAlfred
//
//  Created by admin on 07/03/24.
//

import UIKit

class DashboardViewController: UIViewController {

    
    @IBOutlet var dashboardCategoriesTableview: UITableView!
    @IBOutlet var bottomView: BottomMenuView!
    
    
    var categories = ["Health Hub","Expert Monitoring","List your Symptoms","Lifestyle Goals","Optimal Risk Management"]
    override func viewDidLoad() {
        super.viewDidLoad()
        dashboardCategoriesTableview.register(UINib(nibName: "DashboardCategoriesTableViewCell", bundle: .main), forCellReuseIdentifier: "DashboardCategoriesTableViewCell")

        dashboardCategoriesTableview.delegate = self
        dashboardCategoriesTableview.dataSource = self
        // Do any additional setup after loading the view.
        
        
        
    
    }
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension DashboardViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardCategoriesTableViewCell") as! DashboardCategoriesTableViewCell
        cell.categoriesLabel.attributedText =  customizeInitialLetterInCell(categoryText: categories[indexPath.row])
       
        let defaults = UserDefaults.standard
        var array = defaults.array(forKey: "filledArray")  as? [Int] ?? [Int]()
        
        if(array.contains(indexPath.row))
        {
            cell.bgView.backgroundColor = UIColor(named: "CompletedBG")
        }
        else
        {
            cell.bgView.backgroundColor = UIColor(named: "PendingBG")

        }
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if(indexPath.row == 0)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let popup = storyboard.instantiateViewController(withIdentifier: "HealthHubViewController") as! HealthHubViewController
          
            popup.modalPresentationStyle = .overCurrentContext
            present(popup, animated: true, completion: nil)

        }
        else if(indexPath.row == 1)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let popup = storyboard.instantiateViewController(withIdentifier: "ExpertMonitoringViewController") as! ExpertMonitoringViewController
          
            popup.modalPresentationStyle = .overCurrentContext
            present(popup, animated: true, completion: nil)
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
    
    
    func customizeInitialLetterInCell(categoryText:String) -> NSMutableAttributedString
    {
        // Create an attributed string
        let attributedString = NSMutableAttributedString(string: categoryText)
        
        // Apply different attributes to the first letter
        attributedString.addAttribute(.foregroundColor, value: UIColor(hex: "1C77CA") ?? UIColor.blue, range: NSRange(location: 0, length: 1)) // Change color
        
        // Change font to Poppins for the first letter
        let poppinsFont = UIFont(name: "Poppins-Bold", size: 35) ?? UIFont.systemFont(ofSize: 24)
        attributedString.addAttribute(.font, value: poppinsFont, range: NSRange(location: 0, length: 1))
        
        // Set the attributed string to the label
        return attributedString

    }
}
