import UIKit

class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var forwardButton: UIButton! // Assuming you have a UIButton for forward navigation
    @IBOutlet weak var backwardButton: UIButton! // Assuming you have a UIButton for backward navigation

    let calendar = Calendar.current
    var dates: [Date] = []
    var selectedIndex = 0
    let initialLoadCount = 7 // Display a fixed number of days, such as 1 week

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false // Disable scrolling

        // Initialize and set the custom layout
        let customLayout = CustomFlowLayout()
        collectionView.collectionViewLayout = customLayout

        // Start from today's date
        generateDates(startingFrom: Date(), count: initialLoadCount, isForward: false)

        // Select today's date
        scrollToToday()
    }

    @IBAction func forwardClicked(_ sender: Any) {
        let lastDate = dates.last ?? Date()
        let today = Date()

        // Only generate more dates if the last date is before today
        if calendar.compare(lastDate, to: today, toGranularity: .day) == .orderedAscending {
            generateDates(startingFrom: lastDate, count: initialLoadCount, isForward: true)
        }
    }

    @IBAction func backwardClicked(_ sender: Any) {
        let firstDate = dates.first ?? Date()
        generateDates(startingFrom: firstDate, count: initialLoadCount, isForward: false)
    }

    func generateDates(startingFrom startDate: Date, count: Int, isForward: Bool) {
        var newDates: [Date] = []

        for i in 0..<count {
            let offset = isForward ? i : -i - 1
            if let date = calendar.date(byAdding: .day, value: offset, to: startDate) {
                newDates.append(date)
            }
        }

        if isForward {
            dates.append(contentsOf: newDates)
            // Ensure that the dates do not go beyond today
            dates = dates.filter { calendar.compare($0, to: Date(), toGranularity: .day) != .orderedDescending }
        } else {
            dates = newDates.reversed() + dates
        }

        // Disable the forward button if the last date is today
        if let lastDate = dates.last, calendar.isDateInToday(lastDate) {
            forwardButton.isEnabled = false
        } else {
            forwardButton.isEnabled = true
        }

        // Reload collection view data without animation
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as? CalendarCell else {
            return UICollectionViewCell()
        }

        let date = dates[indexPath.item]
        let isSelected = indexPath.item == selectedIndex
        cell.configure(with: date, isSelected: isSelected)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Adjust the size to fit 7 items on the screen
        let collectionWidth = collectionView.frame.width
        let itemWidth = collectionWidth / 7.0
        return CGSize(width: itemWidth, height: 120)
    }

    // Handle selection to update selected index
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        collectionView.reloadData()
    }

    func scrollToToday() {
        if let todayIndex = dates.firstIndex(where: { calendar.isDateInToday($0) }) {
            selectedIndex = todayIndex
            collectionView.reloadData()
        }
    }
}

class CustomFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        scrollDirection = .horizontal
        itemSize = CGSize(width: collectionView!.bounds.width / 7, height: 120) // Set for 7 days
        minimumLineSpacing = 0 // No spacing between cells
    }
}

