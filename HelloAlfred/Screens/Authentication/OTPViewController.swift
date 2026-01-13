//
//  OTPViewController.swift
//  FirstPass
//
//  Created by SkeinTechnologies on 07/09/20.
//  Copyright © 2020 SkeinTechnologies. All rights reserved.
//

import UIKit

class OTPViewController: BaseViewController
{
    
    @IBOutlet weak var resendVoiceButton: UIButton!
    @IBOutlet var otpSentLabel: UILabel!
    @IBOutlet weak var txtOTP4: UITextField!
    @IBOutlet weak var txtOTP3: UITextField!
    @IBOutlet weak var txtOTP2: UITextField!
    @IBOutlet weak var txtOTP1: UITextField!
       
    @IBOutlet var otpView2: Myview!
    @IBOutlet var otpView1: Myview!
    @IBOutlet var otpView3: Myview!
    
    @IBOutlet var otpView4: Myview!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    var isFromForgotPassword:Bool = false
      var otpSentLabelText = ""
      var timer: Timer?
      var remainingTime = 30
    var isFromSignIN:Bool = false
    var userData:SignupUserData?
    let viewModel=AuthViewModel()

    override func viewDidLoad() {
           
           super.viewDidLoad()
           // Do any additional setup after loading the view, typically from a nib.
           
           txtOTP1.backgroundColor = UIColor.clear
           txtOTP2.backgroundColor = UIColor.clear
           txtOTP3.backgroundColor = UIColor.clear
           txtOTP4.backgroundColor = UIColor.clear
           
           addDoneButtonToNumberPad(textField: txtOTP1)
           addDoneButtonToNumberPad(textField: txtOTP2)
           addDoneButtonToNumberPad(textField: txtOTP3)
           addDoneButtonToNumberPad(textField: txtOTP4)

           txtOTP1.delegate = self
           txtOTP2.delegate = self
           txtOTP3.delegate = self
           txtOTP4.delegate = self
           
           txtOTP1.becomeFirstResponder()
        highLightFocusedView(focusedView: otpView1)
        otpSentLabel?.text = otpSentLabelText
        setupResendButton()
        startTimer()
    }
       
    @IBAction func verifyClicked(_ sender: Any) {
        var otp = getOTPString()
        if isValidOTP(otp)
        {
            verifyOTPApiCall(otp: otp)
        }
        else
        {
            showAlert("Please enter the OTP")
        }
        
        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func resendButtonTapped(_ sender: UIButton) {
        // Implement OTP resend logic here
        print("Resend OTP")
            generateOTPApiCall(smsType: "sms")
    }
    
    
    @IBAction func resendCallButtonTapped(_ sender: UIButton) {
//        if let mobile = userData?.mobile, !mobile.isEmpty {
            generateOTPApiCall(smsType: "voice")
//        } else {
//            self.showAlert("Mobile number not found.")
//        }
    }
    
       func setupResendButton() {
           if isFromForgotPassword == false {
               resendVoiceButton.isHidden = true
           }
           resendVoiceButton.isEnabled = false
           resendButton.isEnabled = false
           resendButton.alpha = 0.5
           resendVoiceButton.alpha = 0.5
       }
       
       func startTimer() {
           remainingTime = 30
           timerLabel.text = ""
           resendButton.setTitle("Resend passcode over text(\(remainingTime))", for: .normal)
           resendVoiceButton.setTitle("Resend passcode over call(\(remainingTime))", for: .normal)
           timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
       }
       
       func resetTimer() {
           timer?.invalidate()
           startTimer()
           setupResendButton()
       }
       
       @objc func updateTimer() {
           if remainingTime > 0 {
               remainingTime -= 1
               timerLabel.text = ""
               resendButton.setTitle("Resend passcode over text(\(remainingTime))", for: .normal)
               resendVoiceButton.setTitle("Resend passcode over call(\(remainingTime))", for: .normal)
           } else {
               timer?.invalidate()
               timerLabel.text = ""
               resendButton.setTitle("Resend passcode over text", for: .normal)
               resendVoiceButton.setTitle("Resend passcode over call", for: .normal)
               resendVoiceButton.isEnabled = true
               resendButton.isEnabled = true
               resendButton.alpha = 1.0
               resendVoiceButton.alpha = 1.0
           }
       }
    func getOTPString() -> String {
            let otp1 = txtOTP1.text ?? ""
            let otp2 = txtOTP2.text ?? ""
            let otp3 = txtOTP3.text ?? ""
            let otp4 = txtOTP4.text ?? ""
            return otp1 + otp2 + otp3 + otp4
        }
    func isValidOTP(_ otp: String) -> Bool {
        return otp.count == 4 && otp.allSatisfy { $0.isNumber }
    }
    
    
    func verifyOTPApiCall(otp:String)
    {
        self.view.endEditing(true)
        let params = [
            "email": userData?.email ?? UserDefaults.standard.string(forKey: "Email") ?? "",
            "otp": otp
        ] as [String : Any]
        
        
        print("params \(params)")
        
        viewModel.verifyOTP(params: params)
        viewModel.verifyOTPSuccess = 
        {
            if !self.isFromSignIN {
                print("success")
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                let popup = storyboard.instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController
                popup.userData = self.userData
                popup.modalPresentationStyle = .overCurrentContext
                self.present(popup, animated: true, completion: nil)
            } else {
                UserDefaults.standard.set(true, forKey: "IS_LOGGED_IN")
                self.navigateTo(viewController: DashboardViewController.self, withIdentifier: "DashboardViewController")
            }
            
            self.navigateTo(viewController: OpticalRiskManagementViewController.self, withIdentifier: "OpticalRiskManagementViewController")
        }
        viewModel.loadingStatus =
        {
            if self.viewModel.isLoading {
                self.activityIndicator(self.view, startAnimate: true)
            } else 
            {
                self.activityIndicator(self.view, startAnimate: false)
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
        viewModel.errorMessageAlert = {
            self.showAlertWithHandler(message: self.viewModel.errorMessage ?? "Error",  okActionTitle: "Okay", enableCancel: false)
            {
                _ in
            }
        }
    }
    func generateOTPApiCall(smsType: String)
    {
        timerLabel.text = "Sending OTP"
        self.view.endEditing(true)
        var params: [String: Any]
        if(userData?.firstName == nil)
        {
             params = [
                "email": userData?.email ?? "",
                "username":  "\(userData?.firstName ?? "") \(userData?.lastName ?? "")",
                "mobile": userData?.mobile ?? "",
                "sms_type" : smsType
            ] as [String : Any]
        }
        else
        {
            params = [
                "email": userData?.email ?? "",
                "username": "\(userData?.firstName ?? "") \(userData?.lastName ?? "")",
                "mobile": userData?.mobile ?? "",
                "sms_type" : smsType
            ] as [String : Any]
        }
        print("params \(params)")
        viewModel.generateOTP(params: params)
        viewModel.generateOTPSuccess = {
            self.timerLabel.text = "OTP sent successfully."
            self.resetTimer()

        }
        viewModel.errorMessageAlert = {
            self.resetTimer()
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
       
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           if ((textField.text?.count)! < 1 ) && (string.count > 0) {
               if textField == txtOTP1 {
                 highLightFocusedView(focusedView: otpView2)
                   
                   
                   txtOTP2.becomeFirstResponder()
               }
               
               if textField == txtOTP2 {
                   highLightFocusedView(focusedView: otpView3)

                   txtOTP3.becomeFirstResponder()
               }
               
               if textField == txtOTP3 {
                   highLightFocusedView(focusedView: otpView4)
                   txtOTP4.becomeFirstResponder()
               }
             
               
               textField.text = string
               return false
           } else if ((textField.text?.count)! >= 1) && (string.count == 0) {
               if textField == txtOTP2 {
                   highLightFocusedView(focusedView: otpView1)

                   txtOTP1.becomeFirstResponder()
               }
               if textField == txtOTP3 {
                   highLightFocusedView(focusedView: otpView2)

                   txtOTP2.becomeFirstResponder()
               }
               if textField == txtOTP4 {
                   highLightFocusedView(focusedView: otpView3)

                   txtOTP3.becomeFirstResponder()
               }
              
               
               textField.text = ""
               return false
           } else if (textField.text?.count)! >= 1 {
               print("laasstt");
               textField.text = string
               return false
           }
           
           return true
       }
       override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
       }
    
    func highLightFocusedView(focusedView:UIView)
    {
        
        if(focusedView == otpView1)
        {
            otpView1.layer.masksToBounds = false
            otpView1.borderColor = UIColor(red: 66/255, green: 157/255, blue: 173/255, alpha: 1)
            otpView1.layer.shadowColor = UIColor(red: 66/255, green: 157/255, blue: 173/255, alpha: 1).cgColor
            otpView1.layer.shadowOpacity = 0.4
            otpView1.layer.shadowOffset = CGSize.zero
            otpView1.layer.shadowRadius = 5
            otpView2.layer.borderColor = UIColor(red: 185/255, green: 196/255, blue: 210/255, alpha: 1).cgColor
            otpView2.layer.shadowOpacity = 0.0
            otpView3.layer.borderColor = UIColor(red: 185/255, green: 196/255, blue: 210/255, alpha: 1).cgColor
            otpView3.layer.shadowOpacity = 0.0

            otpView4.layer.borderColor = UIColor(red: 185/255, green: 196/255, blue: 210/255, alpha: 1).cgColor
            otpView4.layer.shadowOpacity = 0.0


        }
        else if(focusedView == otpView2)
        {
            otpView2.layer.masksToBounds = false
            otpView2.borderColor = UIColor(red: 66/255, green: 157/255, blue: 173/255, alpha: 1)
            otpView2.layer.shadowColor = UIColor(red: 66/255, green: 157/255, blue: 173/255, alpha: 1).cgColor
            otpView2.layer.shadowOpacity = 0.4
            otpView2.layer.shadowOffset = CGSize.zero
            otpView2.layer.shadowRadius = 5
            otpView1.layer.borderColor = UIColor(red: 185/255, green: 196/255, blue: 210/255, alpha: 1).cgColor
            otpView3.layer.borderColor = UIColor(red: 185/255, green: 196/255, blue: 210/255, alpha: 1).cgColor
            otpView4.layer.borderColor = UIColor(red: 185/255, green: 196/255, blue: 210/255, alpha: 1).cgColor
            
            otpView4.layer.shadowOpacity = 0.0
            otpView3.layer.shadowOpacity = 0.0
            otpView1.layer.shadowOpacity = 0.0


        }
        else if(focusedView == otpView3)
        {
            otpView3.layer.masksToBounds = false
            otpView3.borderColor = UIColor(red: 66/255, green: 157/255, blue: 173/255, alpha: 1)
            otpView3.layer.shadowColor = UIColor(red: 66/255, green: 157/255, blue: 173/255, alpha: 1).cgColor
            otpView3.layer.shadowOpacity = 0.4
            otpView3.layer.shadowOffset = CGSize.zero
            otpView3.layer.shadowRadius = 5
            otpView1.layer.borderColor = UIColor(red: 185/255, green: 196/255, blue: 210/255, alpha: 1).cgColor
            otpView2.layer.borderColor = UIColor(red: 185/255, green: 196/255, blue: 210/255, alpha: 1).cgColor
            otpView4.layer.borderColor = UIColor(red: 185/255, green: 196/255, blue: 210/255, alpha: 1).cgColor
            
            otpView4.layer.shadowOpacity = 0.0
            otpView2.layer.shadowOpacity = 0.0
            otpView1.layer.shadowOpacity = 0.0

        }else if(focusedView == otpView4)
        {
            otpView4.layer.masksToBounds = false
            otpView4.borderColor = UIColor(red: 66/255, green: 157/255, blue: 173/255, alpha: 1)
            otpView4.layer.shadowColor = UIColor(red: 66/255, green: 157/255, blue: 173/255, alpha: 1).cgColor
            otpView4.layer.shadowOpacity = 0.4
            otpView4.layer.shadowOffset = CGSize.zero
            otpView4.layer.shadowRadius = 5
            otpView1.layer.borderColor = UIColor(red: 185/255, green: 196/255, blue: 210/255, alpha: 1).cgColor
            otpView3.layer.borderColor = UIColor(red: 185/255, green: 196/255, blue: 210/255, alpha: 1).cgColor
            otpView2.layer.borderColor = UIColor(red: 185/255, green: 196/255, blue: 210/255, alpha: 1).cgColor
            otpView2.layer.shadowOpacity = 0.0
            otpView3.layer.shadowOpacity = 0.0
            otpView1.layer.shadowOpacity = 0.0
        }
    }
    
    
}

