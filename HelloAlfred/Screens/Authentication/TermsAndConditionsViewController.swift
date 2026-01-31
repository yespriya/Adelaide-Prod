import UIKit

class TermsAndConditionsViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var termsAndConditionsTextView: UITextView!
    @IBOutlet var checkboxButton: UIButton! // Checkbox button added
    @IBOutlet var acceptButton: UIButton! // Accept button to proceed
    
    @IBOutlet var shareButton: Mybutton!
    
    @IBOutlet var bottomViewHeight: NSLayoutConstraint!

    let viewModel = AuthViewModel()
    var isChecked = false // To track checkbox state
    var email = String()
    var isFromSideMenu: Bool = false
    var isAccepted:((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        termsAndConditionsTextView.delegate = self
//        fetchTermsAndConditions()
        self.updateUI()
        setupCheckbox()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bottomViewHeight.constant = isFromSideMenu ? 0 : 120
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func acceptButtonTapped(_ sender: UIButton) {
        dismissWithData(selectedData: isChecked)

    }
    @IBAction func shareButtonTapped(_ sender: Any) {
        sendTNCApiCall()
    }
    
    func setupCheckbox() {
        // Set the checkbox button appearanc o;[hp./>/
        checkboxButton.isSelected = isChecked // Update button selection state
        checkboxButton.setImage(UIImage(named: "unchecked"), for: .normal) // Unchecked state
        checkboxButton.setImage(UIImage(named: "checked"), for: .selected) // Checked state
        checkboxButton.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
        acceptButton.isEnabled = isChecked
        shareButton.isEnabled = isValidEmail(email: email)
    }
    
    @objc func checkboxTapped(_ sender: UIButton) {
        isChecked.toggle() // Toggle the checkbox state
        sender.isSelected = isChecked // Update button selection state
        acceptButton.isEnabled = isChecked 
    }
    
    /*
    func fetchTermsAndConditions() {
        viewModel.fetchTermsAndConditions()
        viewModel.fetchTermsAndContionsSuccess = {
            self.updateUI()
        }
        viewModel.errorMessageAlert = {
            self.showAlert(self.viewModel.errorMessage ?? "Error")
        }
        viewModel.loadingStatus =
        {
            if self.viewModel.isLoading {
                self.activityIndicator(self.view, startAnimate: true)
            } else {
                self.activityIndicator(self.view, startAnimate: false)
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
    }
    */
    
    func sendTNCApiCall()
    {
        self.view.endEditing(true)
        let params = [
            "email": email
        ] as [String : Any]
        print("params \(params)")
        
        viewModel.sendTNC(params: params)
        viewModel.sendTNCSuccess =
        {
            self.showAlert(self.viewModel.sendTNCRes?.message ?? "Success")
        }
        
        viewModel.loadingStatus =
        {
            if self.viewModel.isLoading {
                self.activityIndicator(self.view, startAnimate: true)
            } else {
                self.activityIndicator(self.view, startAnimate: false)
            }
        }
        viewModel.errorMessageAlert = {
            self.showAlert(self.viewModel.errorMessage ?? "")
        }
    }
    
    func updateUI() {
        // Convert HTML to attributed string
        if let data = Constants.termsAndPolicy.data(using: .utf8) {
            do {
                let attributedString = try NSAttributedString(data: data,
                                                              options: [.documentType: NSAttributedString.DocumentType.html,
                                                                        .characterEncoding: String.Encoding.utf8.rawValue],
                                                              documentAttributes: nil)
                // Assign attributed string to text view
                termsAndConditionsTextView.attributedText = attributedString
            } catch {
                print("Error converting HTML: \(error)")
            }
        }
        
        // Optional: Customize appearance of UITextView
        termsAndConditionsTextView.dataDetectorTypes = [.link]
        termsAndConditionsTextView.isEditable = false
        termsAndConditionsTextView.isSelectable = true
    }
    
    // Call this method when you want to dismiss and send data back
    func dismissWithData(selectedData:Bool) {
        isAccepted?(selectedData)
        self.dismiss(animated: true, completion: nil)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if let privacyVC = Constants.mainStoryBoard.instantiateViewController(withIdentifier: "PrivacyPolicyView") as? PrivacyPolicyView {
            privacyVC.urlToLoad = URL.absoluteString
            privacyVC.modalPresentationStyle = .overFullScreen
            present(privacyVC, animated: true, completion: nil)
        }
        return false
    }    
}
