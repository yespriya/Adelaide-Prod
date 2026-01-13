import UIKit

class ConnectDeviceViewController: UIViewController {
    
    @IBOutlet var bgImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func connectDeviceClicked(_ sender: Any) {
        
        
        navigateTo(viewController: ActiveDeviceViewController.self, withIdentifier: "ActiveDeviceViewController")
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
}
