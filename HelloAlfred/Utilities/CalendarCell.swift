import UIKit

class CalendarCell: UICollectionViewCell {
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var indicatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 19
        contentView.layer.masksToBounds = true
    }

    func configure(with date: Date, isSelected: Bool) {
        let calendar = Calendar.current
        
        // Abbreviate month to first three letters
        let month = calendar.shortMonthSymbols[calendar.component(.month, from: date) - 1]
        let day = calendar.component(.day, from: date)
        
        // Get the full name of the weekday and then use only the first letter
        let weekdayFullName = calendar.weekdaySymbols[calendar.component(.weekday, from: date) - 1]
        let weekdayFirstLetter = String(weekdayFullName.prefix(1))

        monthLabel.text = month
        dayLabel.text = weekdayFirstLetter
        weekDayLabel.text = String(format: "%02d", day)
        // Only the first letter
        
        dayLabel.textColor = isSelected ? .white : .black
        weekDayLabel.textColor = isSelected ? .white : .black
        monthLabel.textColor = isSelected ? .white : .black
        contentView.backgroundColor = isSelected ? .black : .white
        indicatorView.backgroundColor = isSelected ? .black : .white

        // Hide the indicator view when not selected
    }
}

