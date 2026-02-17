//
//  ForgotPasswordViewController.swift
//  HelloAlfred
//
//  Created by admin on 22/05/24.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {

    @IBOutlet var emailPhoneTextFeild: UnderlinedTextField!
    
    let viewModel=AuthViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        emailPhoneTextFeild.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func continueClicked(_ sender: Any) {
        guard let input = emailPhoneTextFeild.text, !input.isEmpty else {
            self.showAlert("Please enter email or mobile number.")
            return
        }
        
        if isValidEmailOrPhone(input) {
            generateOTPApiCall(input: input)
        } else {
            self.showAlert("Please enter email or mobile number.")
        }
    }
    
    @IBAction func LoginClicked(_ sender: Any) {
        navigateTo(viewController: SignInViewController.self, withIdentifier: "SignInViewController")
    }
    
    func generateOTPApiCall(input: String) {
        
        self.view.endEditing(true)
        var params:[String: Any] = [:]
        
        if isValidMobile(input) {
            params = [
                "mobile": input,
                "sms_type" : "sms"
            ]
        } else {
            params = [
                "email": input,
                "sms_type" : "sms"
            ]
        }
        
        print("params \(params)")
        
        viewModel.generateOTP(params: params)
        viewModel.generateOTPSuccess = {
           print("success")
            
            var userData: SignupUserData
            
            if self.isValidMobile(input) {
                userData = SignupUserData(firstName: nil,lastName: nil, email: nil, dob: nil, gender: nil, mobile: input, rtype: nil, education: nil, ssn: nil, insuranceurl: nil, password: nil)
            } else {
                userData = SignupUserData(firstName: nil,lastName: nil, email: input, dob: nil, gender: nil, mobile: nil, rtype: nil, education: nil, ssn: nil, insuranceurl: nil, password: nil)
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let popup = storyboard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
            if self.viewModel.generateOTPRes?.statuscode == 200 {
                popup.otpSentLabelText = self.viewModel.generateOTPRes?.message ?? ""
            } else {
                popup.otpSentLabelText = ""
            }
            popup.userData = userData
            popup.modalPresentationStyle = .overCurrentContext
            self.present(popup, animated: true, completion: nil)
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
//                let storyboard = UIStoryboard(name: "Main", bundle: .main)
//                let popup = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
//                popup.userData = self.userData
//                popup.modalPresentationStyle = .overCurrentContext
//                self.present(popup, animated: true, completion: nil)

               
                
            }
        }
    }
    

}
