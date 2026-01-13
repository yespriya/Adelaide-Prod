import UIKit

class TermsAndConditionsViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var termsAndConditionsTextView: UITextView!
    @IBOutlet var checkboxButton: UIButton! // Checkbox button added
    @IBOutlet var acceptButton: UIButton! // Accept button to proceed
    
    @IBOutlet var shareButton: Mybutton!
    weak var delegate: TermsAndConditionsViewControllerDelegate?

    let viewModel = AuthViewModel()
    var isChecked = false // To track checkbox state
    var email = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        termsAndConditionsTextView.delegate = self
        fetchTermsAndConditions()
        setupCheckbox()
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
        if let data = viewModel.termsAndConditionsRes?.data?.result?.data(using: .utf8) {
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
        delegate?.didDismissWithData(selectedData)
        self.dismiss(animated: true, completion: nil)
    }
    
    @nonobjc func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        // Handle the URL here
        UIApplication.shared.open(URL)
        return false
    }
    
    
}

protocol TermsAndConditionsViewControllerDelegate: AnyObject {
    func didDismissWithData(_ data: Bool)
}
