
import UIKit

class ListOfSymptomsViewController: UIViewController {
    
    @IBOutlet weak var tableviewTop: NSLayoutConstraint!
    @IBOutlet var lastUpdatedDataLabel: UILabel!
    @IBOutlet var prevSymptomsDetailsView: Myview!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var symptomsTableView: UITableView!
    
    var symptomsList = ["Breathlessness during activity","Breathlessness even at rest","Dizziness","Cold sweat","Pronounced tiredness","Chest pain","Pressure/ discomfort in chest","Worry","Weakness","Infirmity","Near syncope","Syncope","Tiredness afterwards"]
    let viewModel = SymptomsViewModel()
    let dashboardViewModel = DashboardViewModel()
    var userSymtomps = [UserSymptomsData]()
    var userSelectedValues = [UserSymptomsData]()
    
    
    var dropDownedIndexes = [Int()]
    
    override func viewDidLoad() {
        dropDownedIndexes.removeAll()
        super.viewDidLoad()
        titleLabel.attributedText = customizeInitialLetter(categoryText: titleLabel.text!)
        
        symptomsTableView.register(UINib(nibName: "SymptomsTableViewCell", bundle: .main), forCellReuseIdentifier: "SymptomsTableViewCell")
        fetchLastUpdateDetailsApiCall()
        symptomsTableView.delegate = self
        symptomsTableView.dataSource = self
    }
    
    
    @IBAction func proceedClicked(_ sender: Any) {
        
        showAlertWithHandler(message: "Are you sure to submit the entered details?", okActionTitle: "Submit", enableCancel: true, okActionHandler: {_ in
            self.addSymptomsApiCall()
        })
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func infoTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: "LastUpdatedDetailsViewController") as! LastUpdatedDetailsViewController
        vc.fromListOfSymptoms = true
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    func addSymptomsApiCall()
    {
        var params = [:
        ] as [String : Any]
        userSelectedValues.forEach { val in
            // Define a dictionary to map categoryIndex to parameter keys
            let categoryKeys = [
                0: "breathnessda",
                1: "breathnessea",
                2: "dizziness",
                3: "col_swet",
                4: "p_tiredness",
                5: "chest_pain",
                6: "pressurechest",
                7: "worry",
                8: "weakness",
                9: "infirmity",
                10: "nsynacpe",
                11: "syncope"
            ]
            
            // Use the dictionary to set the parameters
            if let key = categoryKeys[val.categoryIndex ?? 0] {
                params[key] = [
                    "frequency": "\(val.frequency ?? "")",
                    "severity": val.severity,
                    "quality_of_life": val.eql == false ? "No" : val.eql == true ? "Yes" : nil
                ]
            } else {
                print("Incorrect val")
            }
        }
        
        
        print("params \(params)")
        
        viewModel.addSymptoms(params: params)
        viewModel.symptomsUpdateSuccess = {
            self.showAlertWithHandler(message: self.viewModel.addSymptomsRes?.message ?? "Error", okActionTitle: "OKay", enableCancel: false, okActionHandler: {_ in
                let defaults = UserDefaults.standard
                var array = defaults.array(forKey: "filledArray")  as? [Int] ?? [Int]()
                
                self.updateUserStatusApiCall()
            })
            
        }
        viewModel.loadingStatus =
        {
            if self.viewModel.isLoading {
                self.activityIndicator(self.view, startAnimate: true)
            } else {
                self.activityIndicator(self.view, startAnimate: false)
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
        viewModel.errorMessageAlert = {
            print(self.viewModel.errorMessage ?? "Error")
//            self.showAlert(self.viewModel.errorMessage ?? "Error")
        }
    }
    
    func fetchLastUpdateDetailsApiCall()
    {
        viewModel.fetchLastUpdateListofSymptoms()
        viewModel.lastUpdateSymptomsFetchSuccess = {
            if(!(self.viewModel.lastUpdateSymptomsRes!.data!.difference == nil))
            {
                self.prevSymptomsDetailsView.isHidden = false
                self.tableviewTop.constant = 80
                self.updateLastUpdateLabel(healthData: self.viewModel.lastUpdateSymptomsRes!.data!)
            }
            else
            {
                self.prevSymptomsDetailsView.isHidden = true
                self.tableviewTop.constant = 0
            }
        }
        viewModel.loadingStatus =
        {
            if self.viewModel.isLoading {
                self.activityIndicator(self.view, startAnimate: true)
            } else {
                self.activityIndicator(self.view, startAnimate: false)
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
        viewModel.errorMessageAlert = {
            print(self.viewModel.errorMessage ?? "Error")
//            self.showAlert(self.viewModel.errorMessage ?? "Error")
            self.prevSymptomsDetailsView.isHidden = true
            self.tableviewTop.constant = 0
            
        }
    }
    
    func updateUserStatusApiCall()
    {
        let params: [String: Any] = [
            "list_your_symptoms": 1,
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
            print(self.dashboardViewModel.errorMessage ?? "Error")
//            self.showAlert(self.dashboardViewModel.errorMessage ?? "Error")
        }
    }
    
    func doesSymptomsExist(selectedcCategoryIndex: Int, in userSymtomps: [UserSymptomsData]) -> Int? {
        // Iterate over the array of QAObject
        for (index, symptomsObject) in userSymtomps.enumerated() {
            // Check if the question matches
            if symptomsObject.categoryIndex == selectedcCategoryIndex {
                return index
            }
        }
        // Question not found
        return nil
    }
    func updateLastUpdateLabel(healthData:HealthUpdateData) {
        // Determine the difference text
        let differenceText = (healthData.difference == "0") ? "today" : "\(healthData.difference ?? "") days ago"
        
        // Construct the full text based on the difference
        let fullText = "You, Last gave your symptoms \(differenceText) on \(healthData.date ?? "")"
        
        // Create the attributed string
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // Define the ranges for the words you want to color
        let range1 = (fullText as NSString).range(of: healthData.date ?? "")
        let range2 = (fullText as NSString).range(of: healthData.difference == "0" ? "today" : (healthData.difference ?? ""))
        
        // Apply colors to the specific ranges
        if let appThemeColor = UIColor(named: "AppTheme") {
            attributedString.addAttribute(.foregroundColor, value: appThemeColor, range: range1)
            attributedString.addAttribute(.foregroundColor, value: appThemeColor, range: range2)
        }
        
        lastUpdatedDataLabel.attributedText = attributedString
    }
}
extension ListOfSymptomsViewController: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symptomsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SymptomsTableViewCell") as! SymptomsTableViewCell
        cell.symptomTitle.text = symptomsList[indexPath.row]
        cell.sliderValueChanged = { value in
            // Handle slider value change here
            switch value{
            case 0.0:
                self.updateSliderValue(intValue: 0, value: "None", indexVal: indexPath.row)
            case 25.0:
                self.updateSliderValue(intValue: 25, value: "Mild", indexVal: indexPath.row)
            case 50.0:
                self.updateSliderValue(intValue: 50, value: "Moderate", indexVal: indexPath.row)
            case 75.0:
                self.updateSliderValue(intValue: 75, value: "Severe", indexVal: indexPath.row)
            case 100.0:
                self.updateSliderValue(intValue: 100, value: "Extreme", indexVal: indexPath.row)
            default:
                print("details need not to be included")
            }
        }
        
        // Handle dropdown button tap
        cell.dropDownButtonTappedHandler = {
            if self.dropDownedIndexes.contains(indexPath.row) {
                self.dropDownedIndexes.remove(at: self.dropDownedIndexes.firstIndex(of: indexPath.row)!)
            } else {
                self.dropDownedIndexes.append(indexPath.row)
            }
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
            if(indexPath.row == lastRowIndex)
            {
                if lastRowIndex >= 0 {
                    let indexPath = IndexPath(row: lastRowIndex, section: 0)
                    tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
            
            // Reload data to update cell heights
        }
        
        cell.frequencyButtonTappedHandler = {
            if let index = self.doesSymptomsExist(selectedcCategoryIndex: indexPath.row, in: self.userSelectedValues) {
                // Update the value inside the object
                self.userSelectedValues[index].frequency = cell.selectedFrequencyValue
            } else {
                // Add a new object to the array
                self.userSelectedValues.append(UserSymptomsData(categoryIndex: indexPath.row, frequency: cell.selectedFrequencyValue, severity: nil, eql: nil))
            }
        }
        cell.EQLButtonTappedHandler = {
            if let index = self.doesSymptomsExist(selectedcCategoryIndex: indexPath.row, in: self.userSelectedValues) {
                // Update the value inside the object
                self.userSelectedValues[index].eql = cell.EQLValue
                print("Value updated")
            } else {
                // Add a new object to the array
                print("Added")
                self.userSelectedValues.append(UserSymptomsData(categoryIndex: indexPath.row, frequency: nil, severity: nil, eql: cell.EQLValue))
            }
        }
        
        self.dropDownedIndexes.contains(indexPath.row) ? cell.dropDownButton.setImage(UIImage(named: "up-arrow"), for: .normal) : cell.dropDownButton.setImage(UIImage(named: "down-arrow"), for: .normal)
        // Set bgView visibility based on dropdown state
        cell.bgView.isHidden = !self.dropDownedIndexes.contains(indexPath.row)
        cell.titleBottomConstraint.constant = 8
        cell.titleBottomConstraint.isActive = !self.dropDownedIndexes.contains(indexPath.row)
        //        cell.contentView.backgroundColor = UIColor.red
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return self.dropDownedIndexes.contains(indexPath.row) ? 352 : 55
    //    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44 // Provide an estimated height for smoother scrolling
    }
    func updateSliderValue(intValue:Int, value:String,indexVal:Int)
    {
        print(intValue)
        if let index = self.doesSymptomsExist(selectedcCategoryIndex: indexVal, in: self.userSelectedValues) {
            // Update the value inside the object
            self.userSelectedValues[index].severity = intValue.description
        } else {
            // Add a new object to the array
            self.userSelectedValues.append(UserSymptomsData(categoryIndex: indexVal, frequency:nil, severity: intValue.description, eql: nil))
        }
    }
}

