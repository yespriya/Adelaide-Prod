
import UIKit


class LifeStyleCategoryViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var goalsTableView: UITableView!
    @IBOutlet var proceedButton: UIButton!
    var goals = ["Diet","Exercise","Weight","Blood pressure"]
    var selectedGoalIndex = [-1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.attributedText = customizeInitialLetter(categoryText: titleLabel.text!)

        goalsTableView.delegate = self
        goalsTableView.dataSource = self
        proceedButton.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 0.2), for: .disabled);
        proceedButton.isEnabled = false
        goalsTableView.register(UINib(nibName: "goalCategoriesTableViewCell", bundle: .main), forCellReuseIdentifier: "goalCategoriesTableViewCell")
    }
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func proceedClicked(_ sender: Any) {
        navigateTo(viewController: GoalConfirmationViewController.self, withIdentifier: "GoalConfirmationViewController")
    }
    

}
extension LifeStyleCategoryViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let existingIndex = selectedGoalIndex.firstIndex(of: indexPath.row) {
                // Remove the index if it already exists
                selectedGoalIndex.remove(at: existingIndex)
            } else {
                // Add the index if it does not exist
                selectedGoalIndex.append(indexPath.row)
            }
        self.goalsTableView.reloadData()
        self.proceedButton.isEnabled = true
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalCategoriesTableViewCell") as! goalCategoriesTableViewCell
        cell.categoriesLabel.text =   goals[indexPath.row]
        
        if(selectedGoalIndex.contains(indexPath.row))
        {
            cell.radioButton.setImage(UIImage(named: "radiochecked"), for: .normal)
            cell.bgView.backgroundColor = UIColor(hex: "04C1D6")
            cell.categoriesLabel.textColor = UIColor.white
        }
        else
        {
            cell.radioButton.setImage(UIImage(named: "radiounchecked"), for: .normal)
            cell.bgView.backgroundColor = UIColor(hex: "F3F8FC")
            cell.categoriesLabel.textColor = UIColor(hex: "2C2C37")

        }
        cell.radioButtonTappedHandler =
        {
            if let existingIndex = self.selectedGoalIndex.firstIndex(of: indexPath.row) {
                    // Remove the index if it already exists
                self.selectedGoalIndex.remove(at: existingIndex)
                } else {
                    // Add the index if it does not exist
                    self.selectedGoalIndex.append(indexPath.row)
                }            
            self.goalsTableView.reloadData()
            self.proceedButton.isEnabled = true
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
