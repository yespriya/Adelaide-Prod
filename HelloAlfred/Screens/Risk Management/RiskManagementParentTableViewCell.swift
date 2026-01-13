import UIKit

class RiskManagementParentTableViewCell: UITableViewCell {

    @IBOutlet var riskListTableView: UITableView!
    @IBOutlet var backView: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!

    var isFlipped = false
    var sectionNumber: Int = 0 {
        didSet { updateUI() }
    }

    let riskDetails = [
        ["Refer to your managing my AF and risk of stroke guide", "Learn about your AF medicines", "Keep an up-to-date list of medications"],
        ["Take your AF medications as instructed", "Ensure regular blood tests if on Warfarin", "Visit doctors regularly"],
        ["Know your stroke risk factors", "Choose a healthy lifestyle", "Feel your pulse daily"]
    ]
    
    let riskImages = ["risk-management-image1", "risk-management-image2", "risk-management-image3"]

    override func awakeFromNib() {
        super.awakeFromNib()
        setupAppearance(view: containerView)
        setupAppearance(view: backView)

        riskListTableView.register(UINib(nibName: "RiskListTableViewCell", bundle: .main), forCellReuseIdentifier: "RiskListTableViewCell")
        riskListTableView.delegate = self
        riskListTableView.dataSource = self
    }

    private func setupAppearance(view: UIView) {
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowRadius = 2
        view.layer.masksToBounds = false
    }

    private func updateUI() {
        headerImageView.layer.cornerRadius = 12
        descriptionLabel.text = riskDetails[sectionNumber][0]
        headerImageView.image = UIImage(named: riskImages[sectionNumber])
        riskListTableView.reloadData()
    }

    func flipCell() {
        let (fromView, toView) = isFlipped ? (backView, containerView) : (containerView, backView)
        UIView.transition(from: fromView!, to: toView!, duration: 0.6, options: [.showHideTransitionViews, isFlipped ? .transitionFlipFromLeft : .transitionFlipFromRight]) {
            _ in self.isFlipped.toggle()
        }
    }
}

extension RiskManagementParentTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return riskDetails[sectionNumber].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RiskListTableViewCell") as! RiskListTableViewCell
        cell.titleLabel.text = riskDetails[sectionNumber][indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 28
    }
}

