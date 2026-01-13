//
//  ChatFeedbackViewController.swift
//  HelloAlfred
//
//  Created by admin on 08/10/24.
//

import UIKit

class ChatFeedbackViewController: UIViewController {
    
    @IBOutlet var chipsView: ChipsView!
    @IBOutlet var remarksTextView: InputTextView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var chipData = ["Shouldn’t have used memory","Don’t like the style","Didn’t fully follow instructions","Being Lazy","Refuse when it shouldn’t have","Not factually correct","Unsafe or problematic"]
    var remarkText: ((String?) -> Void)?
    
    // MARK: - Navigation
    
    @IBAction func submitTapped(_ sender: Any) {
        remarkText?(remarksTextView.text)
        dismiss(animated: false)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: false)
    }
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: false)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    func configUI()
    {
        chipsView.chips = chipData
        chipsView.chipTapped = { chipData in
            self.remarkText?(chipData)
            self.dismiss(animated: false)
        }
        remarksTextView.placeholder = "Enter remarks"
        registerForKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShows),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHides),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    @objc func keyboardWillShows(notification: Notification) {
        guard let keyboardFrame =
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }

        let keyboardHeight = keyboardFrame.height

        UIView.animate(withDuration: 0.3) {
            self.bottomConstraint.constant = keyboardHeight + 8
            self.view.layoutIfNeeded()
        }
    }
    @objc func keyboardWillHides(notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
