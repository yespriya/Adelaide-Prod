//
//  HelloAlfred
//
//  Created by admin on 06/03/24.
//

import UIKit

class ChangePasswordViewController: BaseViewController {
    @IBOutlet var oldPasswordTextFeild: UnderlinedTextField!

    @IBOutlet var confirmPasswordTextFeild: UnderlinedTextField!
    @IBOutlet var passwordTextFeild: UnderlinedTextField!
    @IBOutlet weak var passwordToggleBtn: UIButton!
        @IBOutlet weak var confirmPasswordToggleBtn: UIButton!
    var userData:SignupUserData?
    let viewModel=AuthViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPasswordToggle()
        setupConfirmPasswordToggle()
        passwordTextFeild.delegate = self
        confirmPasswordTextFeild.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func continueClicked(_ sender: Any) {
        if(!isValidPassword(passwordTextFeild.text ?? ""))
        {
            self.showAlert("Please enter valid password.")
        }
        else if(passwordTextFeild.text == "" || passwordTextFeild.text == nil)
        {
            self.showAlert("Please enter password")

        }
        else if(confirmPasswordTextFeild.text == "" || confirmPasswordTextFeild.text == nil)
        {
            self.showAlert("Please enter confirm password")

        }

       else if(passwordTextFeild.text == confirmPasswordTextFeild.text)
       {
           changePasswordApiCall()
   
        }
        else
        {
            self.showAlert("Both password should be same!")
        }
    }
    
    func setupPasswordToggle() {
           passwordToggleBtn.setImage(UIImage(systemName: "eye")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
           passwordToggleBtn.setImage(UIImage(systemName: "eye.slash")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .selected)
           passwordToggleBtn.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
       }
       
       func setupConfirmPasswordToggle() {
           confirmPasswordToggleBtn.setImage(UIImage(systemName: "eye")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
           confirmPasswordToggleBtn.setImage(UIImage(systemName: "eye.slash")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .selected)
           confirmPasswordToggleBtn.addTarget(self, action: #selector(toggleConfirmPasswordVisibility), for: .touchUpInside)
       }
       
       @objc func togglePasswordVisibility() {
           passwordTextFeild.isSecureTextEntry.toggle()
           passwordToggleBtn.isSelected = !passwordTextFeild.isSecureTextEntry
       }
       
       @objc func toggleConfirmPasswordVisibility() {
           confirmPasswordTextFeild.isSecureTextEntry.toggle()
           confirmPasswordToggleBtn.isSelected = !confirmPasswordTextFeild.isSecureTextEntry
       }
   
    
    
    func changePasswordApiCall()
    {
        self.view.endEditing(true)
        let params = [
            "old_password": oldPasswordTextFeild.text ?? "",
            "new_password": confirmPasswordTextFeild.text ?? "",

        ] as [String : Any]
        
        
        print("params \(params)")
        
        viewModel.changePassword(params: params)
        viewModel.changePasswordSuccess = {
            print("success")
            self.showAlertWithHandler(message: self.viewModel.changePasswordRes?.message ?? "Success",  okActionTitle: "Okay", enableCancel: false)
            {
                _ in
                // Handle OK button click action here
                self.dismiss(animated: true)
                
            }
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


}


