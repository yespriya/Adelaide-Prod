
import UIKit

class GoalConfirmationViewController: UIViewController {

    @IBOutlet var nameTextFeild: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        var name = defaults.string(forKey: "Username")
        nameTextFeild.text = "Hello \(name!)"

    }
    

    @IBAction func OKPressed(_ sender: Any) {
//        sleep(2)
        weak var pvc = self.presentingViewController

        self.dismiss(animated: true, completion: {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let popup = storyboard.instantiateViewController(withIdentifier: "SetTimePeriodViewController") as! SetTimePeriodViewController
            popup.modalPresentationStyle = .overCurrentContext
            pvc?.present(popup, animated: true, completion: nil)
        })
       
    }
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    // Define a delay function
    func delay(by seconds: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: closure)
    }
}
