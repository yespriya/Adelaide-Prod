
import UIKit
import Highcharts

class HealthDetailsViewController: BaseViewController {
    
    @IBOutlet var filterDataUnAvailableView: UIView!
    @IBOutlet var scrollDownImg: UIImageView!
    @IBOutlet var scrollButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var lineChartView: HIChartView!
    @IBOutlet var pulseTextFeild: UITextField!
    @IBOutlet var weightTextFeild: UITextField!
    
    
    @IBOutlet var combinedHealthAndPulseHeightConstraint: NSLayoutConstraint!
    @IBOutlet var dateTextFeild: UnderlinedTextField!
    @IBOutlet var checkBoxButton: UIButton!
    let viewModel = HealthDetailsViewModel()
    let dashboardViewModel = DashboardViewModel()
    @IBOutlet var chartViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var diastolicErrorLabel: UILabel!
    @IBOutlet var systolicErrorLabel: UILabel!
    @IBOutlet var pulseErrorLabel: UILabel!
    @IBOutlet var weightErrorLabel: UILabel!
    @IBOutlet var chartView: UIView!
    @IBOutlet var endDateTextField: UITextField!
    @IBOutlet var startDateTextField: UITextField!
    @IBOutlet var diastolicBPTextField: UITextField!
    @IBOutlet var systolicBPTextField: UITextField!
    @IBOutlet var lastUpdateSymptomsLabel: UILabel!
    
    @IBOutlet var noHealthDetailsView: UIView!
    @IBOutlet var prevHealthDetailsView: Myview!
    
    var tappedTextFeild = UITextField()

    var xAxisCategories = [String()]
    var systolicData = [Float()]
    var diastolicData = [Float()]
    var weightData = [Float()]
    var pulseData = [Float()]
    var checkBoxChecked = false
    
    // Boolean to track scroll position
    var isAtBottom = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        combinedHealthAndPulseHeightConstraint.isActive = false
        setupDelegates()
//        addDoneButtonToNumberPad(textField: heightTextFeild)
        addDoneButtonToNumberPad(textField: systolicBPTextField)
        addDoneButtonToNumberPad(textField: diastolicBPTextField)
        addDoneButtonToNumberPad(textField: weightTextFeild)
        weightTextFeild.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        systolicBPTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        diastolicBPTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        pulseTextFeild.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    
        fetchLinearChartApiCall(startDate: "", endDate: "")
        // Get the current date
        let currentDate = Date()
               
        // Create a DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Set the desired date format
               
        // Format the date as a string
        let dateString = dateFormatter.string(from: currentDate)
        updateButtonImage()
        dateTextFeild.text = dateString
        
        scrollDownImg.layer.shadowRadius = 5
        scrollDownImg.layer.shadowOpacity = 0.8
        scrollDownImg.layer.shadowOffset = CGSize(width: 1, height: 1)
        scrollDownImg.layer.shadowColor = UIColor.black.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLastUpdateDetailsApiCall()
    }
    
    func adjustViewHeight()
    {
        if(self.viewModel.LinearChartDataRes?.statuscode == 204)
        {
            chartView.isHidden = true
            chartViewHeightConstraint.constant = 280
        }
        else
        {
            chartView.isHidden = false
            chartViewHeightConstraint.constant = 380
        }
    }
    
    
    func scrollToBottom()
    {
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    func scrollToTop()
    {
        let topOffset = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(topOffset, animated: true)
    }
    
    @IBAction func scrollTapped(_ sender: Any) {
        if isAtBottom
        {
                    scrollToTop()
        } else {
                    scrollToBottom()
                }
                isAtBottom.toggle()
                updateButtonImage()
    }
    
    @IBAction func infoTapped(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let vc = storyboard.instantiateViewController(withIdentifier: "LastUpdatedDetailsViewController") as? LastUpdatedDetailsViewController {
//            vc.fromListOfSymptoms = false
//            vc.modalPresentationStyle = .fullScreen // Optional: Set presentation style
//            present(vc, animated: true, completion: nil)
//        }
        
        navigateTo(viewController: LastUpdatedDetailsViewController.self, withIdentifier: "LastUpdatedDetailsViewController",animated: false)
    }
    
    
    @IBAction func filterSubmitTapped(_ sender: Any) {
        
        if(startDateTextField.text != "" && startDateTextField.text != nil && endDateTextField.text != "" && endDateTextField.text != nil)
        {
            fetchLinearChartApiCall(startDate: startDateTextField.text!, endDate: endDateTextField.text!)

        }
        else
        {
            showAlert("Please select the dates")
        }

    }
    
    func setupDelegates()
    {
        pulseTextFeild.delegate = self
        systolicBPTextField.delegate = self
        diastolicBPTextField.delegate = self
        weightTextFeild.delegate = self
        dateTextFeild.delegate = self
        startDateTextField.delegate = self
        endDateTextField.delegate = self
        
        scrollView.delegate = self

    }
    
    func fetchLinearChartApiCall(startDate:String, endDate:String)
    {
        let params: [String: Any] = ["start_date":startDate,
                                     "end_date":endDate
        ]
        
        print("params   \(params)")
        viewModel.fetchLinearChartData(params: params)
        viewModel.LinearChartDataFetchSuccess = {
            let chartData = self.viewModel.LinearChartDataRes?.data ?? []
            print("ccoount \(chartData.count)")
            if(chartData.count == 0)
            {
                print("11")
                self.filterDataUnAvailableView.isHidden = false
            }
            else
            {
                print("12")
                for data in chartData {
                    self.xAxisCategories.append(data.tdate ?? "")
                    self.systolicData.append(Float(data.systolic_p ?? 0))
                    self.diastolicData.append(Float(data.diastolic_p ?? 0))
                    self.weightData.append(Float(data.weight ?? "0") ?? 0)
                    self.pulseData.append(Float(data.pulse ?? "0") ?? 0)
                }
                self.filterDataUnAvailableView.isHidden = true
                self.createChart()
            }
            self.adjustViewHeight()
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
//            self.fetchLastUpdateDetailsApiCall()
            self.filterDataUnAvailableView.isHidden = false
//            self.showAlert(self.viewModel.errorMessage ?? "Error")
        }
    }
    func createChart() {
        

            // Chart options
            let options = HIOptions()
            options.credits.enabled = false
            // Chart
            let chart = HIChart()
            chart.type = "line"
            options.chart = chart

            // Title
            let title = HITitle()
            title.text = "Health Records"
            options.title = title

            // X Axis
            let xAxis = HIXAxis()
            xAxis.categories = xAxisCategories
            options.xAxis = [xAxis]

            // Y Axis
            let yAxis = HIYAxis()
            yAxis.title = HITitle()
            yAxis.title.text = "Value"
            options.yAxis = [yAxis]

            // Data Series
            let systolic = HISeries()
            systolic.name = "Systolic"
            systolic.data = systolicData
            let diastolic = HISeries()
            diastolic.name = "Diastolic"
            diastolic.data = diastolicData
        let pulse = HISeries()
        pulse.name = "Pulse"
        pulse.data = pulseData
        let weight = HISeries()
        weight.name = "Weight"
        weight.data = weightData
        options.series = [systolic,diastolic,weight,pulse]
        
        let exporting = HIExporting()
        exporting.enabled = false

        options.exporting = exporting

            // Set the options to the chart view
            lineChartView.options = options
        }

    
    func fetchLastUpdateDetailsApiCall()
    {
        viewModel.fetchLastUpdateHealthDetail()
        viewModel.lastUpdateHealthDetailsFetchSuccess = {
       
            if(!(self.viewModel.lastUpdateHealthRes!.data!.difference == nil))
            {
                self.prevHealthDetailsView.isHidden = false
                self.updateLastUpdateLabel(healthData: self.viewModel.lastUpdateHealthRes!.data!)
            }
            else
            {
                self.prevHealthDetailsView.isHidden = true
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
            self.filterDataUnAvailableView.isHidden = false
//            self.showAlert(self.viewModel.errorMessage ?? "Error")
           
        }
    }
    func updateLastUpdateLabel(healthData:HealthUpdateData) {
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

        lastUpdateSymptomsLabel.attributedText = attributedString
    }
    
    @IBAction func checkBoxTapped(_ sender: Any) 
    {
        checkBoxChecked = !checkBoxChecked
        
        if(checkBoxChecked)
        {
            checkBoxButton.setImage(UIImage(named: "checked"), for: .normal)
        }
        else
        {
            checkBoxButton.setImage(UIImage(named: "unchecked"), for: .normal)

        }
    }
    
    @IBAction func proceedClicked(_ sender: Any) {
        
        let isWeightValid = validateInput(for: weightTextFeild)
            let isPulseValid = validateInput(for: pulseTextFeild)
            let isSystolicValid = validateInput(for: systolicBPTextField)
            let isDiastolicValid = validateInput(for: diastolicBPTextField)
            
            if isWeightValid && isPulseValid && isSystolicValid && isDiastolicValid {
                // All inputs are valid, proceed with API call
                showAlertWithHandler(message: "Are you sure to submit the entered details?", okActionTitle: "Submit", enableCancel: true, okActionHandler: {_ in
                    self.addHealthDetailsApiCall()
                })
                
            }
            else
            {
              print("Validation Failed")
            }
    }
    
    func addHealthDetailsApiCall()
    {
        /*
        let params = [
            "weight": weightTextFeild!.text! == "" ? nil : weightTextFeild!.text!,
           "tdate": dateTextFeild.text! == "" ? nil : dateTextFeild.text!,
            "bloodp": "\(systolicBPTextField.text!)/\(diastolicBPTextField.text!)",
            "pulse": pulseTextFeild.text!,
        ] as [String : Any] */
        
        let params = AddHealthDetailsModel(tdate: dateTextFeild.text, weight: weightTextFeild.text, pulse: pulseTextFeild.text, bloodp: "\(systolicBPTextField.text!)/\(diastolicBPTextField.text!)").toDictionary()
        
        print("params \(params)")
        
        viewModel.updateHealthDetails(params: params)
        viewModel.healthDetailsUpdateSuccess = {
           print("success")
            self.showAlertWithHandler(message: self.viewModel.updateHealthDetailsRes?.message ?? "Error", okActionTitle: "OKay", enableCancel: false, okActionHandler: {_ in
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
            self.showAlert(self.viewModel.errorMessage ?? "Error")
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
       var validateData = validateInput(for: textField)
    }

    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            // Limit for weightTextField to 4 digits
            if textField == weightTextFeild {
                let maxLength = 4
                let currentString: NSString = textField.text! as NSString
                let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
                // Check if the new string is numeric and within 4 digits
                return newString.length <= maxLength && CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
            }
            
            // Limit for other text fields to 3 characters (letters or numbers)
            let maxLength = 3
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            
            // Allow only alphanumeric characters (letters and numbers)
            let allowedCharacters = CharacterSet.letters.union(.decimalDigits)
            let characterSet = CharacterSet(charactersIn: string)
            
            // Ensure the new string length is within the limit and contains only allowed characters
            return newString.length <= maxLength && allowedCharacters.isSuperset(of: characterSet)
        }
    
    
    func validateInput(for textField: UITextField) -> Bool {
        var isValid = true
        
        if textField == weightTextFeild {
            if let text = textField.text, !text.isEmpty, let number = Int(text) {
                if number >= 22 && number <= 1400 {
                    weightErrorLabel.text = "" // Valid weight
                } else {
                    weightErrorLabel.text = "Weight should be between 22 and 1400"
                    isValid = false
                }
            } else {
                weightErrorLabel.text = "Invalid weight value"
                isValid = false
            }
        } else if textField == pulseTextFeild {
            if let text = textField.text, !text.isEmpty, let number = Int(text) {
                if number >= 27 && number <= 200 {
                    pulseErrorLabel.text = "" // Valid pulse
                } else {
                    pulseErrorLabel.text = "Pulse should be between 27 and 200"
                    isValid = false
                }
            } else {
                pulseErrorLabel.text = "Invalid pulse value"
                isValid = false
            }
        } else if textField == systolicBPTextField {
            if let text = textField.text, !text.isEmpty, let number = Int(text) {
                if number >= 0 && number <= 370 {
                    systolicErrorLabel.text = "" // Valid systolic BP
                } else {
                    systolicErrorLabel.text = "Systolic BP should be between 0 and 370"
                    isValid = false
                }
            } else {
                systolicErrorLabel.text = "Invalid systolic BP value"
                isValid = false
            }
        } else if textField == diastolicBPTextField {
            if let text = textField.text, !text.isEmpty, let number = Int(text) {
                if number >= 0 && number <= 360 {
                    diastolicErrorLabel.text = "" // Valid diastolic BP
                } else {
                    diastolicErrorLabel.text = "Diastolic BP should be between 0 and 360"
                    isValid = false
                }
            } else {
                diastolicErrorLabel.text = "Invalid diastolic BP value"
                isValid = false
            }
        }
        
        return isValid
    }

    
    func updateUserStatusApiCall()
    {
        let params: [String: Any] = [
            "expert_monitoring": 1,
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
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true)
    }
}
extension HealthDetailsViewController:DatePickerDelegate{
    
    func selectedDate(date: String) {
        print("date \(date)")
        if(tappedTextFeild == dateTextFeild)
        {
            dateTextFeild.text = date;
        }
        else if(tappedTextFeild == startDateTextField)
        {
            startDateTextField.text = date
//            fetchLinearChartApiCall(startDate: date, endDate: "")

        }
        else if(tappedTextFeild == endDateTextField)
        {
            //initial implementation with validation
            if(startDateTextField.text != "" && startDateTextField.text != nil)
            {
                if(compareDates(firstDateString: startDateTextField.text ?? "", secondDateString: date))
                {
                    endDateTextField.text = date
                    fetchLinearChartApiCall(startDate: startDateTextField.text!, endDate: date)
                }
                else
                {
                    showAlert("Start date should be greater than end date")
                }
            }
            else
            {
                showAlert("Please select the start date")
            }
            /* endDateTextField.text = date
            fetchLinearChartApiCall(startDate: "", endDate: date) */

        }

    }
    
    func cancelDateSelection() {
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
      if (textField == dateTextFeild || textField == startDateTextField || textField == endDateTextField){
          tappedTextFeild = textField
        self.view.endEditing(true)
          let storyboard = UIStoryboard(name: "Main", bundle: .main)
          let popup = storyboard.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
          popup.isTimePicker = false
          popup.modalPresentationStyle = .overCurrentContext
          popup.delegate = self
          present(popup, animated: true, completion: nil)
        return false
      }else{
        return true
      }
    }

    func compareDates(firstDateString: String, secondDateString: String) -> Bool {
        print("fiiir \(firstDateString)   kkk \(secondDateString)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let firstDate = dateFormatter.date(from: firstDateString),
           let secondDate = dateFormatter.date(from: secondDateString) {
            return secondDate >= firstDate
        } else {
            print("One or both of the date strings are invalid.")
            return false
        }
    }
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           view.endEditing(true)
       }
    
}
extension HealthDetailsViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if isScrolledToTop(scrollView) {
                isAtBottom = false
                updateButtonImage()
            }
            
            if isScrolledToBottom(scrollView) {
                isAtBottom = true
                updateButtonImage()
            }
        }

        func isScrolledToTop(_ scrollView: UIScrollView) -> Bool {
            return scrollView.contentOffset.y <= 0
        }
        
        func isScrolledToBottom(_ scrollView: UIScrollView) -> Bool {
            return scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.size.height
        }
    func updateButtonImage() {
            let buttonImage = isAtBottom ? UIImage(named: "scrollup") : UIImage(named: "scrolldown")
        scrollDownImg.image = buttonImage
        }
}

struct AddHealthDetailsModel: Encodable {
    var tdate: String?
    var weight: String?
    var pulse: String?
    var bloodp: String?
}
