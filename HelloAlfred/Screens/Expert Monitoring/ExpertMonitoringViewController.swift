
import UIKit

class ExpertMonitoringViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    //MARK: - lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.attributedText = customizeInitialLetter(categoryText: titleLabel.text!)
        
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func connectDevice(_ sender: Any) {
        
        showAlertWithHandler(message: "The functionalities wont be working for the following modules. Do you like to continue?", okActionTitle: "Continue", enableCancel: true, okActionHandler: {_ in
            
            
            self.navigateTo(viewController: CustomiseDeviceViewController.self, withIdentifier: "CustomiseDeviceViewController")
        })
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func digitalCoachClicked(_ sender: Any) {
        
        
        navigateTo(viewController: HealthDetailsViewController.self, withIdentifier: "HealthDetailsViewController")
    }
    
    
}
