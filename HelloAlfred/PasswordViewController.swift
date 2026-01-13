//
//  PasswordViewController.swift
//  HelloAlfred
//
//  Created by admin on 06/03/24.
//

import UIKit

class PasswordViewController: UIViewController {

    @IBOutlet var confirmPasswordTextFeild: UnderlinedTextField!
    @IBOutlet var passwordTextFeild: UnderlinedTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePlaceholders()
        // Do any additional setup after loading the view.
    }
    
    func configurePlaceholders(){
        let attributes: [NSAttributedString.Key: Any] = [
                    NSAttributedString.Key.font: UIFont(name: "Poppins", size: 14)!,
                    NSAttributedString.Key.foregroundColor: UIColor(hex: "354866")!
                ]
        passwordTextFeild.attributedPlaceholder = NSAttributedString(string: "Enter password", attributes: attributes)
        confirmPasswordTextFeild.attributedPlaceholder = NSAttributedString(string: "Re-enter new password", attributes: attributes)
    }
    @IBAction func continueClicked(_ sender: Any) {
        if(passwordTextFeild.text == "" || passwordTextFeild.text == nil)
        {
            self.showAlert("Please enter Password")

        }
        else if(confirmPasswordTextFeild.text == "" || confirmPasswordTextFeild.text == nil)
        {
            self.showAlert("Please enter Confirm Password")

        }
       else if(passwordTextFeild.text == confirmPasswordTextFeild.text)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let popup = storyboard.instantiateViewController(withIdentifier: "PasswordSuccessViewController") as! PasswordSuccessViewController
            
            popup.modalPresentationStyle = .overCurrentContext
            present(popup, animated: true, completion: nil)
        }
        else
        {
            self.showAlert("Both password should be same!")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
