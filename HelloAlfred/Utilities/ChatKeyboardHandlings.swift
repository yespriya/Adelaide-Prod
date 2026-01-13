import UIKit

protocol KeyboardHandling: AnyObject {
    func adjustForKeyboard(notification: NSNotification, show: Bool)
    func scrollToLast()
}

extension KeyboardHandling where Self: UIViewController {
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension UIViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let handler = self as? KeyboardHandling {
            handler.adjustForKeyboard(notification: notification, show: true)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let handler = self as? KeyboardHandling {
            handler.adjustForKeyboard(notification: notification, show: false)
        }
    }
}

