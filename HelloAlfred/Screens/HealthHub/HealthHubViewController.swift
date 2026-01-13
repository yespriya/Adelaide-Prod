import UIKit
import WebKit
import SwiftSoup

class HealthHubViewController: UIViewController, WeekViewControllerDelegate {
    
    
    @IBOutlet weak var lblWeekDescription: UILabel!
    @IBOutlet weak var lblWeekObjective: UILabel!
    @IBOutlet weak var lblContentDescription: UILabel!
    
    @IBOutlet weak var lblActivities: UILabel!
    
    @IBOutlet weak var lblActivitiesTitle: UILabel!
    @IBOutlet var weeklyContentDetailsTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var weeklyContentDescriptionLabel: UILabel!
    @IBOutlet var weeklyContentTitleLabel: UILabel!
    @IBOutlet var weeklyDetailsTableView: UITableView!
//    @IBOutlet var weekTitleLabel: UILabel!
    @IBOutlet var selectedWeekLabel: UILabel!
    @IBOutlet var linearProgressBar: SteppedLinearProgressBar!
    @IBOutlet var titleText: UILabel!
//    @IBOutlet weak var skipButton: UIButton!
    
    var lastIndexBool: Bool = true
    
    let viewModel = DashboardViewModel()
    var healthViewModel = HealthHubViewModel()
    var weeklyContent: [WeeklyContent?] = []
    var selectedWeek = "week0"
    var selectedWeekQuizKey = "pre_test"
    var lastTrueWeek = 1
    var nextWeekQuizKey:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        titleText.attributedText = customizeInitialLetter(categoryText: titleText.text!)
        fetchInitialData()
    }
    
    @objc func showPopup() {
        let popup = CustomPopupView()
        popup.show(in: self.view)
        
        popup.onRestart = {
            print("onRestart")
        }
        
        popup.onOkay = {
            print("onOkay")
            self.updateHealthHubStatus(type: "Proceed")
        }
    }
    

    
    
    // MARK: - Setup Methods
    private func setupTableView() {
        weeklyDetailsTableView.delegate = self
        weeklyDetailsTableView.dataSource = self
        weeklyContentDetailsTableViewHeightConstraint.constant = 1050
        weeklyDetailsTableView.separatorStyle = .none
        weeklyDetailsTableView.tableFooterView = UIView()
        
//        skipButton.layer.cornerRadius = 5
//        skipButton.layer.borderWidth = 1
//        skipButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func fetchInitialData() {
         self.activityIndicator(self.view, startAnimate: true)
        //        fetchWeeklyStatusApiCall()
        guard !healthViewModel.isLoading else { return }
        fetchWeeklyStatusApiCall()
        fetchDropDownApiCall()
        fetchWeeklyStatusApiCallBelow5()
        fetchWeeklyContentApiCall(selectedWeek: selectedWeek.replacingOccurrences(of: "week", with: ""))
        
    }
    
    // MARK: - Button Actions
    
    @IBAction func proceedClicked(_ sender: Any) {
        if(selectedWeek == "5"){
            showAlertWithHandler(message: "You had completed all the weeks. More content will be available soon!", okActionTitle: "Okay", enableCancel: false, okActionHandler:{_ in
                if(self.selectedWeek == "12") {
                    self.showPopup()
                }else{
                    self.updateHealthHubStatus(type: "Proceed")
                }
            })
        }else {
            if(self.selectedWeek == "12") {
                self.showPopup()
            }else{
                self.updateHealthHubStatus(type: "Proceed")
            }
//            updateHealthHubStatus(type: "Proceed")
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func skipPressed(_ sender: Any) {
        if(selectedWeek == "12"){
            showAlert("Sorry! You cannot skip the 5th week!")
        }else {
            updateHealthHubStatus(type: "Skip")
        }
    }
    
    @IBAction func overViewClicked(_ sender: Any) {
        self.activityIndicator(view.self, startAnimate: true)
        healthViewModel.fetchHealthHubOverviewData()
        healthViewModel.overviewFetchSuccess = { [weak self] in
            guard let self = self else { return }
            self.activityIndicator(view.self, startAnimate: false)
            if let data = self.healthViewModel.overviewRes?.data {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let currentViewController = storyboard.instantiateViewController(withIdentifier: "HealthHubOverViewViewController") as? HealthHubOverViewViewController {
                    currentViewController.afTopics = data
                    present(currentViewController, animated: true)
                }
                //navigateTo(viewController: HealthHubOverViewViewController.self, withIdentifier: "HealthHubOverViewViewController")
            }
        }
        healthViewModel.errorMessageAlert = { [weak self] in
            guard let self = self else { return }
            self.activityIndicator(view.self, startAnimate: false)
            self.showAlert(self.healthViewModel.errorMessage ?? "Error")
        }
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func selectWeekClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let currentViewController = storyboard.instantiateViewController(withIdentifier: "SelectWeekViewController") as? SelectWeekViewController {
            currentViewController.viewModel = healthViewModel
            currentViewController.delegate = self
            currentViewController.modalPresentationStyle = .overCurrentContext
            present(currentViewController, animated: true)
        }
    }
    
    @IBAction func videoButtonClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let currentViewController = storyboard.instantiateViewController(withIdentifier: "VideoListViewController") as? VideoListViewController {
            currentViewController.modalPresentationStyle = .overFullScreen
            present(currentViewController, animated: true)
        }
    }
    
    @IBAction func quizButtonClicked(_ sender: Any) {
//        self.activityIndicator(view.self, startAnimate: true)
        let viewModel = QuizViewModel()
        viewModel.fetchQuizData(with: ["week_number" : selectedWeek == "week0" ? "pre_test" : selectedWeek.replacingOccurrences(of: "week", with: "")])
        viewModel.quizListFetchSuccess = { [weak self] in
            guard let self = self else { return }
            self.activityIndicator(view.self, startAnimate: false)
            
            if !(viewModel.quizResponse?.status ?? true) {
                self.showAlert(viewModel.quizResponse?.message ?? "")
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let currentViewController = storyboard.instantiateViewController(withIdentifier: "QuizViewController") as? QuizViewController {
                    currentViewController.modalPresentationStyle = .overFullScreen
                    print("displaying selected week \(selectedWeek)____> \(selectedWeekQuizKey)")
                    currentViewController.quizKey = selectedWeek.replacingOccurrences(of: "week", with: "") == "0" ? selectedWeekQuizKey.replacingOccurrences(of: "module_", with: "") : selectedWeek.replacingOccurrences(of: "week", with: "")
                    currentViewController.moduelDisplyNumber = selectedWeekLabel.text ?? ""
                    currentViewController.nextWeekQuizKey_pretest = nextWeekQuizKey
                    currentViewController.needToUpdateWeekStatus = { [weak self] status in
                        self?.updateHealthHubStatus(type: "update_complete_week")
                        self?.healthViewModel.fetchWeeklyContent(params: self?.selectedWeek.replacingOccurrences(of: "week", with: "") ?? "")
                        if let data = self?.healthViewModel.dropDownRes?.data {
                            if let dropDownData = data.first, let nextData = data.dropFirst().first {
                                self?.selectedWeekLabel.text = dropDownData.label
                                self?.lblContentDescription.text = dropDownData.title
                                self?.nextWeekQuizKey = self?.nextWeekQuizKey ?? ""
                                self?.selectedWeekQuizKey = dropDownData.quizKey ?? ""
                            }
                        }
                        self?.fetchWeeklyStatusApiCallBelow5()
                    }
                    present(currentViewController, animated: true)
                }
            }
        }
    }
    
    private func fetchWeeklyStatusApiCall() {
        healthViewModel.fetchWeekStatus()
        healthViewModel.weeklyStatusFetchSuccess = { [weak self] in
            guard let self = self else { return }
            self.activityIndicator(view.self, startAnimate: false)
            if lastIndexBool == true {
//                if let weeklyStatusArray = healthViewModel.weeklyStatusRes?.data {
//                    if let lastTrueIndex = weeklyStatusArray.lastIndex(where: { $0.status == true }) {
//                        print("Last true index is \(lastTrueIndex + 1)")
//                        selectedWeekLabel.text = "Module \(lastTrueIndex)"
//                    } else {
//                        print("No true element found in the array.")
//                    }
//                } else {
//                    print("Data is nil.")
//                }
                lastIndexBool = false
            }
            updateDisplayedSections(selectedWeekInt: Int(selectedWeek) ?? 1)
        }
        healthViewModel.errorMessageAlert = {
            self.showAlert(self.healthViewModel.errorMessage ?? "Error")
        }
    }
    
    private func fetchDropDownApiCall() {
        healthViewModel.fetchHealthHubDropDownData()
        healthViewModel.dropDownFetchSuccess = { [weak self] in
            guard let self = self else { return }
            self.activityIndicator(view.self, startAnimate: false)
            if let data = self.healthViewModel.dropDownRes?.data {
                if let dropDownData = data.first, let nextData = data.dropFirst().first {
                    selectedWeekLabel.text = dropDownData.label
                    lblContentDescription.text = dropDownData.title
                    self.nextWeekQuizKey = nextData.quizKey ?? ""
                }
            }
        }
        healthViewModel.errorMessageAlert = {
            self.showAlert(self.healthViewModel.errorMessage ?? "Error")
        }
    }
    
    func calculateRange(selectedWeek: Int, totalWeeks: Int) -> Range<Int> {
        let startIndex = max(0, selectedWeek - 4)
        let endIndex = selectedWeek
        return startIndex..<endIndex
    }
   
    
    private func fetchWeeklyStatusApiCallBelow5() {
        healthViewModel.fetchWeekStatus()
        
        healthViewModel.weeklyStatusFetchSuccess = { [weak self] in
            guard let self = self else { return }
            self.activityIndicator(view.self, startAnimate: false)
            
            guard let detailss = self.healthViewModel.weeklyStatusRes?.data else { return }
            
            // Convert response data into dictionary
            var weeks: [String: Bool] = [:]
            for (key, value) in detailss {
                weeks[key] = value
            }

            let currentWeek = selectedWeek
            var arrayStates: [ProgressState] = []
            
            if weeks[currentWeek] == true {
                arrayStates = [.completed, .completed, .completed, .current]
            } else {
                arrayStates = [.current, .incomplete, .incomplete, .incomplete]
                
            }
            
            // MARK: - Apply to progress bar
            self.linearProgressBar.progressStates.removeAll()
            self.linearProgressBar.progressStates = arrayStates
            self.linearProgressBar.setNeedsDisplay()
            self.linearProgressBar.layoutIfNeeded()
        }
        
        healthViewModel.errorMessageAlert = {
            self.showAlert(self.healthViewModel.errorMessage ?? "Error")
        }
    }
    
    func updateDisplayedSections(selectedWeekInt: Int) {
    }

    
    private func updateHealthHubStatus(type:String) {
        let params: [String: Any] = type == "Skip" ? ["skip_week": selectedWeek] : ["update_current_week": selectedWeek.replacingOccurrences(of: "week", with: "").description, "unlock_next_week": nextWeekQuizKey.replacingOccurrences(of: "module_", with: "")]
        
//        ["update_complete_week": selectedWeek]
        print("params \(params)")
        healthViewModel.updateHealthHubStatus(params: params)
        healthViewModel.healthHubStatusUpdateSuccess = {
            if case let .dataClass(dataClass) = self.healthViewModel.healthHubUpdateStatusRes?.data {
                if dataClass.quizStatus == false {
                    self.showAlert("Please complete the quiz to proceed")
                } else {
                    if(type == "Proceed"){
                        self.updateUserStatusApiCall()
                        
                    }else{
                        DispatchQueue.main.async {
                            self.fetchInitialData()
                        }
                    }
                }
            }

        }
        healthViewModel.loadingStatus = {
            if self.healthViewModel.isLoading {
//                self.activityIndicator(self.view, startAnimate: true)
            } else {
                DispatchQueue.main.async {
                    self.activityIndicator(self.view, startAnimate: false)
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
        healthViewModel.errorMessageAlert = {
                self.showAlert(self.healthViewModel.errorMessage ?? "Error")
        }
    }
    
    private func fetchWeeklyContentApiCall(selectedWeek: String) {
//        let params = ["week": selectedWeek]
        healthViewModel.fetchWeeklyContent(params: selectedWeek)
        healthViewModel.weeklyContentFetchSuccess = { [weak self] in
            guard let self = self else { return }
            self.activityIndicator(view.self, startAnimate: false)
            self.weeklyContent = self.healthViewModel.weeklyContentRes?.data?.content ?? []
            self.weeklyContentTitleLabel.text = self.healthViewModel.weeklyContentRes?.data?.week_title ?? ""
            self.weeklyContentDescriptionLabel.text = self.healthViewModel.weeklyContentRes?.data?.week_desc ?? ""
            self.lblWeekDescription.setHTMLText(self.healthViewModel.weeklyContentRes?.data?.week_explanation ?? "")
            self.lblWeekObjective.text = self.healthViewModel.weeklyContentRes?.data?.week_objective ?? ""
            if let activity = self.healthViewModel.weeklyContentRes?.data?.week_activity, !activity.isEmpty {
                self.lblActivities.text = activity
                self.lblActivitiesTitle.text = "Activites:"
            } else {
                self.lblActivities.text = ""
                self.lblActivitiesTitle.text = ""
            }
            weeklyDetailsTableView.reloadData()
            self.updateTableViewHeight()
        }
        healthViewModel.loadingStatus = {
            print("ppp \(self.healthViewModel.isLoading)")
            if self.healthViewModel.isLoading {
//                self.activityIndicator(self.view, startAnimate: true)
            } else {
                DispatchQueue.main.async {
                    self.activityIndicator(self.view, startAnimate: false)
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
        healthViewModel.errorMessageAlert = {
            self.showAlert(self.healthViewModel.errorMessage ?? "Error")
            
        }
    }
    
    private func updateUserStatusApiCall() {
        let params: [String: Any] = ["health_hub": 1]
        viewModel.updateUserDetails(params: params)
        viewModel.statusUpdateSuccess = {
            self.navigateTo(viewController: DashboardViewController.self, withIdentifier: "DashboardViewController")
        }
        healthViewModel.loadingStatus = {
            if self.healthViewModel.isLoading {
//                self.activityIndicator(self.view, startAnimate: true)
            } else {
                DispatchQueue.main.async {
                    self.activityIndicator(self.view, startAnimate: false)
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
        healthViewModel.errorMessageAlert = {
            self.showAlert(self.healthViewModel.errorMessage ?? "Error")
            
        }
    }
    
    // MARK: - Utility Methods
    private func handleLoadingAndErrors() {
        healthViewModel.loadingStatus = { [weak self] in
            guard let self = self else { return }
            self.activityIndicator(self.view, startAnimate: self.healthViewModel.isLoading)
            print("qqqwww  \(self.healthViewModel.isLoading)")
        }
        healthViewModel.errorMessageAlert = { [weak self] in
            guard let self = self else { return }
            self.showAlert(self.healthViewModel.errorMessage ?? "Error")
        }
    }
    
    private func calculateTotalTableViewHeight() -> CGFloat {
        return (0..<weeklyDetailsTableView.numberOfRows(inSection: 0)).reduce(0) { total, row in
            total + weeklyDetailsTableView.rectForRow(at: IndexPath(row: row, section: 0)).height
        }
    }
    
    private func updateTableViewHeight() {
        DispatchQueue.main.async {
            self.weeklyDetailsTableView.reloadData()
            self.weeklyContentDetailsTableViewHeightConstraint.constant = self.calculateTotalTableViewHeight()
            self.view.layoutIfNeeded()
        }
    }
    
    func didDismissWithData(_ data: HealthHubDropDownData, nextWeekQuizKey: String) {
        selectedWeek = data.value?.replacingOccurrences(of: "week ", with: "") ?? ""
        fetchWeeklyContentApiCall(selectedWeek: data.quizKey?.replacingOccurrences(of: "module_", with: "") ?? "")
        //selectedWeekLabel.text = "Week \(selectedWeek)"
        selectedWeekLabel.text = data.label
        lblContentDescription.text = data.title
        self.nextWeekQuizKey = nextWeekQuizKey
        selectedWeekQuizKey = data.quizKey ?? ""
        fetchWeeklyStatusApiCallBelow5()
        //fetchWeeklyStatusApiCall()
    }
    
    func setHTMLText(_ htmlString: String, to label: UILabel) {
        guard let data = htmlString.data(using: .utf8) else { return }
        
        do {
            let attributedString = try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            
            let font = label.font ?? .systemFont(ofSize: 16)
            // ✅ Force cast to mutable type
            let mutableAttrString = NSMutableAttributedString(attributedString: attributedString)
            
            let fullRange = NSRange(location: 0, length: mutableAttrString.length)
            
            // Preserve bold/italic styles while applying your custom font
            mutableAttrString.enumerateAttribute(.font, in: fullRange, options: []) { value, range, _ in
                if let oldFont = value as? UIFont {
                    let traits = oldFont.fontDescriptor.symbolicTraits
                    if let newDescriptor = font.fontDescriptor.withSymbolicTraits(traits) {
                        let newFont = UIFont(descriptor: newDescriptor, size: font.pointSize)
                        mutableAttrString.addAttribute(.font, value: newFont, range: range)
                    } else {
                        mutableAttrString.addAttribute(.font, value: font, range: range)
                    }
                }
            }
            
            mutableAttrString.addAttribute(.foregroundColor, value: label.textColor ?? .label, range: fullRange)
            
            label.attributedText = mutableAttrString
        } catch {
            print("❌ Error parsing HTML: \(error)")
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension HealthHubViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyContent.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyHealthDetailsTableViewCell", for: indexPath) as? WeeklyHealthDetailsTableViewCell ?? WeeklyHealthDetailsTableViewCell()
        let content = weeklyContent[indexPath.row]
        cell.titleLabel.text = content?.title
//        cell.descriptionLabel.attributedText = htmlToAttributedString(html: content?.description ?? "", fontSize: 14)
        cell.videoLink = content?.video
        cell.imageLink = content?.photo
        cell.thumbnailLink = content?.thumbnail
        cell.indexNumber = indexPath.row
        var items: [WeeklyHealthDetailsTableViewCell.MediaType] = []

        if let video = content?.video, !video.isEmpty {
            items.append(.video(video))
        }
        if let photo = content?.photo, !photo.isEmpty {
            items.append(.image(photo))
        }
        
        cell.mediaItems = items
        cell.videoCollectionView.reloadData()

        DispatchQueue.main.async {
            if cell.mediaItems.count > 0 {
                cell.scrollToPage(page: 0, animated: false) // safe initial scroll
            }
        }
	
        if items.isEmpty {
            cell.vwCollection.isHidden = true
            cell.pageControl.numberOfPages = 0
            cell.rightArrowButton.isHidden = true
            cell.leftArrowButton.isHidden = true

        } else if items.count == 1 {
            cell.vwCollection.isHidden = false
            cell.pageControl.numberOfPages = 1
            cell.rightArrowButton.isHidden = true
            cell.leftArrowButton.isHidden = true

        } else {
            cell.vwCollection.isHidden = false
            cell.pageControl.numberOfPages = items.count
            cell.rightArrowButton.isHidden = false
            cell.leftArrowButton.isHidden = false
        }


//
//        cell.mediaItems = items
//        cell.videoCollectionView.reloadData()
//        cell.pageControl.numberOfPages = items.count
        
//        cell.configUI()
        
        let html = content?.description ?? ""
        let options = fetchSelectOptions(from: html)
        let sortedArray = options.sorted { $0.key < $1.key }.map { "\($0.value)" }
        
        print(options)
        print(sortedArray)
        
        cell.descriptionDropDown.optionArray = sortedArray
        //descriptionDropDown.optionIds = option.ids
        cell.descriptionDropDown.checkMarkEnabled = false
        cell.descriptionDropDown.semanticContentAttribute = .forceRightToLeft
        cell.descriptionDropDown.textColor = .black
        cell.descriptionDropDown.arrowSize = 10
        cell.descriptionDropDown.backgroundColor = UIColor.init(red: 244, green: 245, blue: 250, alpha: 1.0)
        
//        if (content?.video?.isEmpty ?? false) && (content?.video?.isEmpty ?? false) {
//            cell.vwCollection.isHidden = true
//            cell.layoutSubviews()
//        } else {
//            print("------- show collection view")
//            cell.vwCollection.isHidden = false
//            cell.layoutSubviews()
//        }
        
        if options.count == 0 {
            setHTMLText(html, to: cell.descriptionLabel)
            if selectedWeek.replacingOccurrences(of: "week", with: "") == "0" && indexPath.row == 0 {
                cell.onDescriptionTapped = { [self] in
                    let viewModel = QuizViewModel()
                    viewModel.fetchQuizData(with: ["week_number" : selectedWeek.replacingOccurrences(of: "week", with: "") == "0" ? selectedWeekQuizKey.replacingOccurrences(of: "module_", with: "") : selectedWeek.replacingOccurrences(of: "week", with: "")])
                    viewModel.quizListFetchSuccess = { [weak self] in
                        guard let self = self else { return }
                        self.activityIndicator(view.self, startAnimate: false)
                        
                        if !(viewModel.quizResponse?.status ?? true) {
                            self.showAlert(viewModel.quizResponse?.message ?? "")
                        } else {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            if let currentViewController = storyboard.instantiateViewController(withIdentifier: "QuizViewController") as? QuizViewController {
                                currentViewController.modalPresentationStyle = .overFullScreen
                                currentViewController.quizKey = selectedWeek.replacingOccurrences(of: "week", with: "") == "0" ? selectedWeekQuizKey.replacingOccurrences(of: "module_", with: "") : selectedWeek.replacingOccurrences(of: "week", with: "")

                                    currentViewController.needToUpdateWeekStatus = { [weak self] status in
                                        self?.updateHealthHubStatus(type: "update_complete_week")
                                        self?.healthViewModel.fetchWeeklyContent(params: self?.selectedWeek.replacingOccurrences(of: "week", with: "") ?? "")
                                        if let data = self?.healthViewModel.dropDownRes?.data {
                                            if let dropDownData = data.first, let nextData = data.dropFirst().first {
                                                self?.selectedWeekLabel.text = dropDownData.label
                                                self?.lblContentDescription.text = dropDownData.title
                                                self?.nextWeekQuizKey = dropDownData.quizKey ?? ""
                                                self?.selectedWeekQuizKey = dropDownData.quizKey ?? ""
                                            }
                                        }
                                        self?.fetchWeeklyStatusApiCallBelow5()
                                    }
                                
                                present(currentViewController, animated: true)
                            }
                        }
                    }
                }
            }
        }
    
        if sortedArray.count > 0 {
            cell.descriptionDropDown.isHidden = false
            cell.descriptionDropDown.placeholder = sortedArray.first
            cell.dropDownHeightConstraint.constant = 30
            cell.dropDownHeightConstraint.isActive = true
            
            cell.descriptionDropDown.placeholder = sortedArray.first
            
            
            
            let divId = "1"
            if let attributedContent = HTMLParser.parseMedicationContent(html: html, divId: divId) {
                
                let mutableAttributedString = NSMutableAttributedString(attributedString: attributedContent)
                let range = NSRange(location: 0, length: mutableAttributedString.length)
                if let customFont = UIFont(name: "Poppins-Regular", size: 13.0) {
                    mutableAttributedString.addAttribute(.font, value: customFont, range: range)
                }
            
                cell.descriptionLabel.attributedText = mutableAttributedString
            } else {
                cell.descriptionLabel.text = "Content not available"
            }
            tableView.beginUpdates()
            tableView.endUpdates()

            
        }else{
            cell.descriptionDropDown.isHidden = true
            cell.dropDownHeightConstraint.constant = 0
            cell.dropDownHeightConstraint.isActive = true
        }
        
        
        cell.descriptionDropDown.didSelect { selectedText, index, id in
            cell.descriptionDropDown.placeholder = selectedText
            let divId = "\(index + 1)"
            if let attributedContent = HTMLParser.parseMedicationContent(html: html, divId: divId) {
                
                let mutableAttributedString = NSMutableAttributedString(attributedString: attributedContent)
                let range = NSRange(location: 0, length: mutableAttributedString.length)
                if let customFont = UIFont(name: "Poppins-Regular", size: 13.0) {
                    mutableAttributedString.addAttribute(.font, value: customFont, range: range)
                }
                cell.descriptionLabel.attributedText = mutableAttributedString
                //                cell.descriptionLabel.attributedText = attributedContent
            } else {
                cell.descriptionLabel.text = "Content not available"
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        
        
        return cell
    }
    
    
    
    func getDivContent(html: String, divId: String) -> String? {
        let pattern = "<div id=\"\(divId)\">(.*?)</div>"
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators)
            let range = NSRange(location: 0, length: html.utf16.count)
            if let match = regex.firstMatch(in: html, options: [], range: range) {
                let divRange = match.range(at: 1)
                if let swiftRange = Range(divRange, in: html) {
                    return String(html[swiftRange])
                }
            }
        } catch {
            print("Error creating regex: \(error)")
        }
        return nil
    }
    
    
    func extractStrongTagsContent(html: String) -> String {
        var result = ""
        let pattern = "(?:<strong>(.*?)</strong>)|(<li>(.*?)</li>)|(<p>(.*?)</p>)|([^<>]+)"
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators)
            let range = NSRange(location: 0, length: html.utf16.count)
            let matches = regex.matches(in: html, options: [], range: range)
            for match in matches {
                if let strongRange = Range(match.range(at: 1), in: html) {
                    let strongContent = String(html[strongRange])
                    result += "\(strongContent)\n"
                }
                if let listItemRange = Range(match.range(at: 3), in: html) {
                    let listItem = String(html[listItemRange])
                    result += "• \(listItem)\n"
                }
                if let paraRange = Range(match.range(at: 5), in: html) {
                    let paragraph = String(html[paraRange])
                    result += "\(paragraph)\n"
                }
                if let plainTextRange = Range(match.range(at: 6), in: html) {
                    let plainText = String(html[plainTextRange])
                    result += "\(plainText)\n"
                }
            }
        } catch {
            print("Error creating regex: \(error)")
        }
        
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func formatContent(_ content: String) -> NSAttributedString {
        // Split the content into sections based on newlines
        let sections = content.components(separatedBy: "\n")
        
        // Create an NSMutableAttributedString to hold the formatted content
        let attributedString = NSMutableAttributedString()
        
        // Define attributes for headings and body text
        let headingAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.black
        ]
        
        let bodyAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.darkGray
        ]
        
        // Add numbering and formatting to each section
        for (index, section) in sections.enumerated() {
            // Split the section into heading and body
            let components = section.components(separatedBy: ": ")
            
            // Ensure the section has both a heading and a body
            guard components.count >= 2 else { continue }
            
            let heading = "\(index + 1). \(components[0]): "
            let body = components.dropFirst().joined(separator: ": ") + "\n\n"
            
            // Add heading to attributed string
            let attributedHeading = NSAttributedString(string: heading, attributes: headingAttributes)
            attributedString.append(attributedHeading)
            
            // Add body to attributed string
            let attributedBody = NSAttributedString(string: body, attributes: bodyAttributes)
            attributedString.append(attributedBody)
        }
        
        return attributedString
    }
    
    
    
    func formatDetails(with details: [String]) -> NSAttributedString {
        let combinedString = NSMutableAttributedString()
        
        for (index, detail) in details.enumerated() {
            let numberedString = NSMutableAttributedString(string: "\(index + 1). ", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .bold)])
            numberedString.append(NSAttributedString(string: detail, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
            numberedString.append(NSAttributedString(string: "\n")) // Add a newline after each entry
            combinedString.append(numberedString)
        }
        
        return combinedString
    }
    
    
    func fetchSelectOptions(from html: String) -> [String: String] {
        // Regular expression to find the <select> block
        let selectRegex = try! NSRegularExpression(pattern: "<select>(.*?)</select>", options: .dotMatchesLineSeparators)
        
        // Find the <select> content
        if let match = selectRegex.firstMatch(in: html, options: [], range: NSRange(html.startIndex..<html.endIndex, in: html)),
           let selectRange = Range(match.range(at: 1), in: html) {
            let selectContent = String(html[selectRange])
            
            // Regular expression to find all <option> tags within the <select>
            let optionRegex = try! NSRegularExpression(pattern: "<option value=\"(.*?)\">(.*?)</option>", options: [])
            let matches = optionRegex.matches(in: selectContent, options: [], range: NSRange(selectContent.startIndex..<selectContent.endIndex, in: selectContent))
            
            // Extract the value and display text from each <option>
            var options: [String: String] = [:]
            for match in matches {
                if let valueRange = Range(match.range(at: 1), in: selectContent),
                   let textRange = Range(match.range(at: 2), in: selectContent) {
                    let value = String(selectContent[valueRange])
                    let text = String(selectContent[textRange])
                    options[value] = text
                }
            }
            return options
        }
        return [:]
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
