

import UIKit
import SideMenu


class DashboardViewController: UIViewController
{
    @IBOutlet var nameTextFeild: UILabel!
    @IBOutlet var headerView: HeaderMenuView!
    @IBOutlet var dashboardCategoriesTableview: UITableView!
    @IBOutlet var bottomView: BottomMenuView!
    
    let viewModel = DashboardViewModel()
    
    var leftMenu: SideMenuViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
    
    
    var categories = ["Health Hub","Expert Monitoring","List your Symptoms","Lifestyle Goals","Optimal Risk Management"]
    var cartegoriesBG = ["C1DCEB","EBD6D6","FCF4E1","E2FCE1","F0E1FC"]
    override func viewDidLoad()
    {
        super.viewDidLoad()
        bottomView.delegate = self
        headerView.delegate = self
        dashboardCategoriesTableview.register(UINib(nibName: "DashboardColouredTableViewCell", bundle: .main), forCellReuseIdentifier: "DashboardColouredTableViewCell")
        
        dashboardCategoriesTableview.delegate = self
        dashboardCategoriesTableview.dataSource = self
        // Do any additional setup after loading the view.
        let defaults = UserDefaults.standard
        var name = defaults.string(forKey: "Username")
        nameTextFeild.text = "Hello \(name!)"
        getUserStatusApiCall()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func getUserStatusApiCall()
    {
        viewModel.fetchUserStatusDetails()
        viewModel.userStatusFetchSuccess = {
            print("success")
            self.dashboardCategoriesTableview.reloadData()
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
extension DashboardViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardColouredTableViewCell") as! DashboardColouredTableViewCell
        cell.titleLabel.text = categories[indexPath.row]
        cell.initialLabel.text = fetchFirstLetter(of: categories[indexPath.row])
        cell.bgView.backgroundColor = UIColor(hex: cartegoriesBG[indexPath.row])
        let totalWidth = dashboardCategoriesTableview.frame.width
        
        let height = (dashboardCategoriesTableview.frame.height / 10) * 1.5
        
        if(height <= 60)
        {
            cell.titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 16)
            cell.initialLabel.font = UIFont(name: "Poppins-Bold", size: 26)
            
        }else if (height > 60 && height <= 90)
        {
            cell.titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 17)
            cell.initialLabel.font = UIFont(name: "Poppins-Bold", size: 28)
            
        }
        else
        {
            cell.titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 19)
            cell.initialLabel.font = UIFont(name: "Poppins-Bold", size: 30)
            
        }
        
        let statusDetails = viewModel.userStatusRes?.data
        switch indexPath.row {
        case 0:
            cell.bgViewTrailingConstraint.isActive = false
            if statusDetails?.health_hub == 1 {
                cell.initialLabel.textColor = UIColor(named: "Label1")
            } else {
                cell.initialLabel.textColor = UIColor(named: "UnFilledColor")
            }
        case 1:
            cell.bgViewTrailingConstraint.constant = (totalWidth/10) * 3.5
            if statusDetails?.expert_monitoring == 1 {
                cell.initialLabel.textColor = UIColor(named: "Label1")
            } else {
                cell.initialLabel.textColor = UIColor(named: "UnFilledColor")
            }
        case 2:
            cell.bgViewTrailingConstraint.constant = (totalWidth/10) * 2.5
            if statusDetails?.list_your_symptoms == 1 {
                cell.initialLabel.textColor = UIColor(named: "Label1")
            } else {
                cell.initialLabel.textColor = UIColor(named: "UnFilledColor")
            }
        case 3:
            cell.bgViewTrailingConstraint.constant = (totalWidth/10) * 1.5
            
            if statusDetails?.lifestyle_goals == 1 {
                cell.initialLabel.textColor = UIColor(named: "Label1")
            } else {
                cell.initialLabel.textColor = UIColor(named: "UnFilledColor")
            }
        case 4:
            cell.bgViewTrailingConstraint.constant = (totalWidth/10) * 0.5
            cell.bgViewTrailingConstraint.isActive = true
            if statusDetails?.optimal_risk_managemment == 1 {
                cell.initialLabel.textColor = UIColor(named: "Label1")
            } else {
                cell.initialLabel.textColor = UIColor(named: "UnFilledColor")
            }
            // Add more cases for other rows as needed
        default:
            break
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(indexPath.row == 0)
        {
            navigateTo(viewController: HealthHubViewController.self, withIdentifier: "HealthHubViewController")
        }
        else if(indexPath.row == 1)
        {
            
            navigateTo(viewController: ExpertMonitoringViewController.self, withIdentifier: "ExpertMonitoringViewController")
        }
        else if(indexPath.row == 2)
        {
            navigateTo(viewController: ListOfSymptomsViewController.self, withIdentifier: "ListOfSymptomsViewController")
        }
        else if(indexPath.row == 3)
        {
            navigateTo(viewController: LifeStyleCategoryViewController.self, withIdentifier: "LifeStyleCategoryViewController")
        }
        else if(indexPath.row == 4)
        {
            
            navigateTo(viewController: OpticalRiskManagementViewController.self, withIdentifier: "OpticalRiskManagementViewController")
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("height \((dashboardCategoriesTableview.frame.height / 10) * 1.5)")
        return (dashboardCategoriesTableview.frame.height / 10) * 1.5
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
    func fetchFirstLetter(of string: String) -> String? {
        // Ensure the string is not empty
        guard !string.isEmpty else { return nil }
        
        // Get the first character
        let firstCharacter = string[string.startIndex]
        
        // Return the first character as a String
        return String(firstCharacter)
    }
}
