import UIKit

// Step 1: Create a custom UITableViewCell
import UIKit

class SymptomTableViewCell: UITableViewCell {
    
    // Labels for each column
    let symptomLabel = UILabel()
    let frequencyLabel = UILabel()
    let severityLabel = UILabel()
    let qualityLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Setup the layout for the cell
    private func setupViews() {
        symptomLabel.translatesAutoresizingMaskIntoConstraints = false
        frequencyLabel.translatesAutoresizingMaskIntoConstraints = false
        severityLabel.translatesAutoresizingMaskIntoConstraints = false
        qualityLabel.translatesAutoresizingMaskIntoConstraints = false

        // Add all labels to the content view
        contentView.addSubview(symptomLabel)
        contentView.addSubview(frequencyLabel)
        contentView.addSubview(severityLabel)
        contentView.addSubview(qualityLabel)

        // Constraints for the labels
        NSLayoutConstraint.activate([
            // Symptom label
            symptomLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            symptomLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            symptomLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            symptomLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),

            // Frequency label
            frequencyLabel.leadingAnchor.constraint(equalTo: symptomLabel.trailingAnchor, constant: 8),
            frequencyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            frequencyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            frequencyLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),

            // Severity label
            severityLabel.leadingAnchor.constraint(equalTo: frequencyLabel.trailingAnchor, constant: 8),
            severityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            severityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            severityLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),

            // Quality label
            qualityLabel.leadingAnchor.constraint(equalTo: severityLabel.trailingAnchor, constant: 8),
            qualityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            qualityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            qualityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            qualityLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
        ])

        // Set text alignment and font style
        [symptomLabel, frequencyLabel, severityLabel, qualityLabel].forEach { label in
            label.textAlignment = .left // Set alignment to left
            label.font = UIFont.systemFont(ofSize: 14)
        }
    }

}


// Step 2: Create a ViewController for the popup
class SymptomsPopupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Example data for the table
    var tableData: [[String]] = [
        ["breathness", "Never", "None", "None"],
        ["pressurechest", "Occasionally", "None", "None"],
        ["breathnessda", "Always", "None", "None"],
        ["dizziness", "Occasionally", "None", "None"],
        ["chest_pain", "Often", "None", "None"]
    ]

    // Create the table view
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SymptomTableViewCell.self, forCellReuseIdentifier: "SymptomCell")

        // Add the table view to the view
        view.addSubview(tableView)
        
        // Add constraints to the table view
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])

        // Set the popup appearance
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
    }

    // TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SymptomCell", for: indexPath) as! SymptomTableViewCell

        // Fetch row data and assign to the labels
        let row = tableData[indexPath.row]
        cell.symptomLabel.text = row[0]
        cell.frequencyLabel.text = row[1]
        cell.severityLabel.text = row[2]
        cell.qualityLabel.text = row[3]

        return cell
    }

    // Step 3: Add a custom section header to show the table headings
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .lightGray

        let headerLabels = ["Symptom", "Frequency", "Severity", "Effecting quality of life"]
        let labelWidthMultiplier = 0.25

        for i in 0..<4 {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = headerLabels[i]
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 14)

            headerView.addSubview(label)

            // Constraints for the header labels
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: i == 0 ? headerView.leadingAnchor : headerView.subviews[i - 1].trailingAnchor, constant: 16),
                label.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: CGFloat(labelWidthMultiplier)),
                label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
            ])
        }

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40 // Adjust the header height as needed
    }
}

// Step 4: Present the popup
func presentSymptomsPopup(from viewController: UIViewController) {
    let popupVC = SymptomsPopupViewController()

    // Configure the popup presentation style
    popupVC.modalPresentationStyle = .popover
    popupVC.preferredContentSize = CGSize(width: 400, height: 400)
    
    // Present the popup
    viewController.present(popupVC, animated: true, completion: nil)
}

