//
//  PasswordViewController.swift
//  HelloAlfred
//
//  Created by admin on 06/03/24.
//

import UIKit

class PasswordViewController: BaseViewController {
    
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
            if(userData?.firstName == nil && userData?.lastName == nil)
            {
                updatePasswordApiCall()
            }
            else
            {
                signUpApiCall()
            }
            
        }
        else
        {
            self.showAlert("Both password should be same!")
        }
    }
    
    
    func signUpApiCall()
    {
        self.view.endEditing(true)
        self.activityIndicator(self.view, startAnimate: true)
        let params = [
            
            "email": userData?.email ?? "",
            "dob": userData?.dob ?? "",
            "gender": userData?.gender ?? "",
            "mobile":  (userData?.mobile ?? "").removingSpecialCharacters(),
            "rtype": userData?.rtype ?? "",
            "education": userData?.education ?? "",
            "ssn": userData?.ssn ?? "",
            "insuranceurl": "",
            "password": passwordTextFeild.text ?? "",
            "username": "\(userData?.firstName ?? "")  \(userData?.lastName ?? "")",
            "nationality": userData?.nationality ?? ""
        ] as [String : Any]
        
        
        print("params \(params)")
        
        viewModel.signupUser(params: params)
        viewModel.registerSuccess = {
            self.showAlertWithHandler(message: self.viewModel.signupRes?.message ?? "Success",  okActionTitle: "Okay", enableCancel: false)
            {
                _ in
                
                self.navigateTo(viewController: SubscriptionViewController.self, withIdentifier: "SubscriptionViewController")
                
                
            }
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
        viewModel.errorMessageAlert = {
            self.showAlertWithHandler(message: self.viewModel.errorMessage ?? "Error",  okActionTitle: "Okay", enableCancel: false)
            {
                _ in
                // Handle OK button click action here
                //                   self.redirectToSignup()
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                let popup = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
                popup.userData = self.userData
                popup.modalPresentationStyle = .overCurrentContext
                self.present(popup, animated: true, completion: nil)
                
                
                
            }
        }
    }
    func updatePasswordApiCall()
    {
        self.view.endEditing(true)
        self.activityIndicator(self.view, startAnimate: true)
        let params = [
            "email": userData?.email ?? UserDefaults.standard.string(forKey: "Email") ?? "",
            "password": passwordTextFeild.text ?? ""
        ] as [String : Any]
        
        
        print("params \(params)")
        
        viewModel.updatePassword(params: params)
        viewModel.updatePasswordSuccess = {
            self.showAlertWithHandler(message: self.viewModel.updatePasswordRes?.message ?? "Success",  okActionTitle: "Okay", enableCancel: false)
            {
                _ in
                
                self.navigateTo(viewController: SignInViewController.self, withIdentifier: "SignInViewController")
                
                
            }
            
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
        viewModel.errorMessageAlert = {
            self.showAlertWithHandler(message: self.viewModel.errorMessage ?? "Error",  okActionTitle: "Okay", enableCancel: false)
            {
                _ in
                // Handle OK button click action here
                //                   self.redirectToSignup()
                
                
                
            }
        }
    }
    
    @IBAction func signinClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let popup = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        popup.modalPresentationStyle = .overCurrentContext
        present(popup, animated: true, completion: nil)
    }
    func redirectToSignup()
    {
        guard let presentingViewController = self.presentingViewController else {
            return
        }
        
        // Dismiss the first view controller
        presentingViewController.dismiss(animated: true) {
            // Dismiss the second view controller
            presentingViewController.presentingViewController?.dismiss(animated: true, completion: nil)
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


