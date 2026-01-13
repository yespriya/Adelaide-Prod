import UIKit

class DashboardLifeStyleGoalsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Outlets

    @IBOutlet var headerView: HeaderMenuView!
    @IBOutlet var bottomView: BottomMenuView!
    @IBOutlet var goalReachDescriptionLabel: UILabel!
    @IBOutlet var calenderCollectionView: UICollectionView!
    @IBOutlet var goalsPrimaryProgressBar: CircularProgressBar!
    @IBOutlet var lifeStyleLabel: UILabel!
    @IBOutlet var stepsView: Myview!
    @IBOutlet var exerciseView: Myview!
    @IBOutlet var medicationView: Myview!
    @IBOutlet var sleepView: Myview!
    @IBOutlet var calorieView: Myview!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var goalsButton: Mybutton!
    @IBOutlet var activitiesButton: Mybutton!
    @IBOutlet var activityViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var goalsViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var activitiesView: UIView!
    @IBOutlet var goalsView: UIView!
    @IBOutlet var dateLabel: UILabel!
    
    // MARK: - Properties
    
    let calendar = Calendar.current
    var dates: [Date] = []
    var selectedIndex = 0
    let initialLoadCount = 7 // Display a fixed number of days, such as 1 week
    
    var timer: Timer?
    
    let Categories = [
        CategoryDetails(name: "Meditation", unit: "/60 Min", image: "medication_transparent", bgColor: "8B80F8", value: "50", unfilledColour: "685FC9", filledColour: "19C9DD"),
        CategoryDetails(name: "Exercise", unit: "/2 Hrs", image: "exercise_transparent", bgColor: "AF8EFF", value: "1", unfilledColour: "8E6EDA", filledColour: "FCC810"),
        CategoryDetails(name: "Calories", unit: "/580 Kl", image: "calories-transparent", bgColor: "4C5A81", value: "340", unfilledColour: "2A3453", filledColour: "EC8463"),
        CategoryDetails(name: "Sleep", unit: "/8 Hrs", image: "  sleep-transparent", bgColor: "1AC9DD", value: "2", unfilledColour: "10B2C5", filledColour: "4C5A81")
    ]
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        calenderCollectionView.delegate = self
        calenderCollectionView.dataSource = self
        
        // Start from today's date
        generateDates(startingFrom: Date(), count: initialLoadCount, isForward: true)
        bottomView.delegate = self
        headerView.delegate = self
        
        // Select today's date
        scrollToToday()
    }
    
    // MARK: - Collection View Data Source

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == calenderCollectionView {
            return dates.count
        } else {
            return Categories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == calenderCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as? CalendarCell else {
                return UICollectionViewCell()
            }

            let date = dates[indexPath.item]
            let isSelected = indexPath.item == selectedIndex
            cell.configure(with: date, isSelected: isSelected)

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LifeStyleCategoriesCollectionViewCell", for: indexPath) as? LifeStyleCategoriesCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.titleLabel.text = Categories[indexPath.row].name
            cell.categoryImage.image = UIImage(named: Categories[indexPath.row].image)
            cell.bgView.backgroundColor = UIColor(hex: Categories[indexPath.row].bgColor)
            cell.subTitleLabel.text = Categories[indexPath.row].value
            cell.subTitleUnitLabel.text = Categories[indexPath.row].unit
            cell.subTitleSpaceConstraint.constant = 0
            cell.unFilledView.backgroundColor = UIColor(hex: Categories[indexPath.row].unfilledColour)
            cell.filledView.backgroundColor = UIColor(hex: Categories[indexPath.row].filledColour)
            cell.updateFilledViewHeightMultiplier(0.7)
            return cell
        }
    }
    
    // MARK: - Collection View Delegate

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == calenderCollectionView {
            // Adjust the size to fit 7 items on the screen
            let collectionWidth = calenderCollectionView.bounds.width
            let itemWidth = collectionWidth / 7.0
            return CGSize(width: itemWidth, height: 120)
        } else {
            let width = collectionView.frame.width / 2 - 10 // Example: Two cells per row with spacing
            return CGSize(width: width, height: width + 44) // Square cells
        }
    }

    // Handle selection to update selected index
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        
        // Create another DateFormatter for the desired output format
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "d MMMM yyyy"
        outputDateFormatter.locale = Locale(identifier: "en_US") // Ensure the month is spelled in English
        
        // Convert the Date to a formatted string
        let formattedDateString = outputDateFormatter.string(from: dates[indexPath.item])
        
        // Print or use the formatted date string
        dateLabel.text = formattedDateString
        collectionView.reloadData()
    }

    // MARK: - Navigation

    @IBAction func goalsClicked(_ sender: Any) {
       buttonClickUIChanges(selectedButton: "goals")
    }

    @IBAction func activitiesClicked(_ sender: Any) {
        buttonClickUIChanges(selectedButton: "activities")
    }
    
    func buttonClickUIChanges(selectedButton:String)
    {
        goalsButton.setTitleColor(selectedButton == "goals" ? UIColor(named: "SelectedButtonText") : UIColor(named: "FormHeading"), for: .normal)
        activitiesButton.setTitleColor(selectedButton == "activities" ? UIColor(named: "SelectedButtonText") : UIColor(named: "FormHeading"), for: .normal)
        goalsButton.backgroundColor = selectedButton == "goals" ? UIColor(named: "SelectedButtonBG"): UIColor.clear
        activitiesButton.backgroundColor = selectedButton == "activities" ? UIColor(named: "SelectedButtonBG"): UIColor.clear
        if(selectedButton == "goals")
        {
            goalsView.isHidden = false
            activitiesView.isHidden = true
            goalsViewBottomConstraint.isActive = true
            activityViewBottomConstraint.isActive = false
        }
        else
        {
            goalsView.isHidden = true
            activitiesView.isHidden = false
            goalsViewBottomConstraint.isActive = false
            activityViewBottomConstraint.isActive = true
        }
    }
    
    // MARK: - Actions
    func generateDates(startingFrom startDate: Date, count: Int, isForward: Bool) {
        dates.removeAll()

        for i in 0..<count {
            // Calculate offset so today's date is the last date
            let offset = isForward ? -count + i + 1 : -(count - i)
            if let date = calendar.date(byAdding: .day, value: offset, to: startDate) {
                dates.append(date)
            }
        }

        // Debugging print statement to verify the dates generated
        print("Generated Dates: \(dates.map { DateFormatter.localizedString(from: $0, dateStyle: .medium, timeStyle: .none) })")

        // Reload collection view data without animation
        calenderCollectionView.reloadData()
    }

    @IBAction func forwardClicked(_ sender: Any) {
        // Get the date that is one day after the last date
        let lastDate = dates.last ?? Date()
        let today = Date()

        // Only generate more dates if the last date is before today
        if calendar.compare(lastDate, to: today, toGranularity: .day) == .orderedAscending {
            // Start generating from 7 days after the last date
            generateDates(startingFrom: calendar.date(byAdding: .day, value: 7, to: lastDate) ?? lastDate, count: initialLoadCount, isForward: true)
        }
    }


    @IBAction func backwardClicked(_ sender: Any) {
        // Get the date that is one day before the first date
        let firstDate = dates.first ?? Date()
        generateDates(startingFrom: calendar.date(byAdding: .day, value: -1, to: firstDate) ?? firstDate, count: initialLoadCount, isForward: false)
    }

    func scrollToToday() {
        if let todayIndex = dates.firstIndex(where: { calendar.isDateInToday($0) }) {
            selectedIndex = todayIndex

            print("Today Index: \(todayIndex)")
            calenderCollectionView.scrollToItem(at: IndexPath(item: todayIndex, section: 0), at: .centeredHorizontally, animated: true)
            calenderCollectionView.reloadData()
        }
    }

    
    func updateUI() {
        lifeStyleLabel.attributedText = customizeInitialLetter(categoryText: lifeStyleLabel.text!)
        let fullText = goalReachDescriptionLabel.text ?? ""
        
        // Create the attributed string
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // Define the attributes for the word you want to change
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "GoalPercentColor") // Change the color to red
        ]
        let wordToColor = "48%"
        // Find the range of the word you want to change
        if let range = fullText.range(of: wordToColor) {
            let nsRange = NSRange(range, in: fullText)
            // Apply the attributes to that range
            attributedString.addAttributes(attributes, range: nsRange)
        }
        
        // Set the attributed string to the UILabel
        goalReachDescriptionLabel.attributedText = attributedString
        goalsViewBottomConstraint.isActive = true
        activityViewBottomConstraint.isActive = false
        
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
}



