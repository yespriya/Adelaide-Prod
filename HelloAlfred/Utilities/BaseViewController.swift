import UIKit

class BaseViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add tap gesture recognizer to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        setupTextFields()
    }
    
    func setupTextFields() {
        // Assuming all your text fields are subviews of the view controller's view
        for view in self.view.subviews where view is UITextField {
            if let textField = view as? UITextField {
                textField.delegate = self
                if textField.keyboardType == .numberPad {
                    addDoneButtonToKeyboard(for: textField)
                }
            }
        }
    }
    
    func addDoneButtonToKeyboard(for textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.items = [doneButton]
        textField.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Prevent the user from entering whitespaces
        if string.rangeOfCharacter(from: .whitespaces) != nil {
            return false
        }
        return true
    }
}

