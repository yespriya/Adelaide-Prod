//
//  SignInViewController.swift
//  HelloAlfred
//
//  Created by admin on 14/03/24.
//

import UIKit
import AuthenticationServices
import GoogleSignIn

class SignInViewController: BaseViewController {
    let viewModel = AuthViewModel()

    @IBOutlet var helloImage: UIImageView!
    @IBOutlet var passwordTextFeild: UnderlinedTextField!
    @IBOutlet var userNameTextFeild: UnderlinedTextField!
    @IBOutlet weak var toggleButton: UIButton!
    var isFromSignIn: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: "IS_APP_OPENED")
        setupPasswordToggle()
//        setupDelegates()
        helloImage.loadGif(asset:"sigin-hello")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    /*
    func setupDelegates()
     {
         
         passwordTextFeild.delegate = self
         userNameTextFeild.delegate = self
     }
    */
    func setupPasswordToggle() {
         toggleButton.setImage(UIImage(named: "hidepassword"), for: .normal)
         toggleButton.setImage(UIImage(named: "showpassword"), for: .selected)
         toggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
     }
     
     @objc func togglePasswordVisibility() {
         passwordTextFeild.isSecureTextEntry.toggle()
         toggleButton.isSelected = !passwordTextFeild.isSecureTextEntry
     }
    @IBAction func forgotClicked(_ sender: Any) {
        navigateTo(viewController: ForgotPasswordViewController.self, withIdentifier: "ForgotPasswordViewController")
    }
    
    @IBAction func signupClicked(_ sender: Any) {
        
        navigateTo(viewController: SelectAccountViewController.self, withIdentifier: "SelectAccountViewController")
    }
    
    @IBAction func appleLoginClicked(_ sender: Any)
    {
        let provider = ASAuthorizationAppleIDProvider()
           let request = provider.createRequest()
           request.requestedScopes = [.fullName, .email]

           let controller = ASAuthorizationController(authorizationRequests: [request])
           controller.delegate = self
           controller.presentationContextProvider = self
           controller.performRequests()
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        
        if !isValidEmailOrPhone(userNameTextFeild.text ?? "")
        {
            showAlert("Please enter valid email or phone number")

        }
        else if(passwordTextFeild.text == "" || passwordTextFeild.text == nil)
        {
            showAlert("Please enter the Password")
        }
        else
        {
            signinApiCall()
        }
    }
    
    @IBAction func googleLoginClicked(_ sender: Any)
    {
        googleSignInAction()
    }
    
    func signinApiCall()
    {
        isFromSignIn = true
        self.view.endEditing(true)
        let params = [
         "username": userNameTextFeild.text ?? "",
         "password": passwordTextFeild.text ?? "",
         "session_id": "",
         "subdomain": "api.adelaide.helloalfred.ai"
        ] as [String : Any]
        
        
        print("params \(params)")
        
        viewModel.signinUser(params: params)
        viewModel.signInSuccess =
        {
            if let token = self.viewModel.signInData?.data?.token {
                let userdetails = self.decodeJWT(part: token)
                print(userdetails)
                
                UserDefaults.standard.set("Bearer \(self.viewModel.signInData?.data?.token ?? "")", forKey: "Authorization")
                UserDefaults.standard.set(userdetails?["patient_id"] ?? "Invalid ID", forKey: "PateintId")
                UserDefaults.standard.set(userdetails?["username"] ?? "Invalid name", forKey: "Username")
                UserDefaults.standard.set(userdetails?["profilePictureUrl"] ?? "Invalid img", forKey: "ProfileImg")
                UserDefaults.standard.set(userdetails?["email"] ?? "Invalid email", forKey: "Email")
                if let accessArray = userdetails?["has_access"] as? [Int] {
                    if !accessArray.contains(3) {
                        UserDefaults.standard.set(false, forKey: "IS_LOGGED_IN")
                        if let role = userdetails?["role"] as? Int {
                            self.displayLoginPopUpAdmin(role: role)
                        }
                        return
                    }
                }
                if let changePassword = userdetails?["change_pwd"] as? Bool {
                    if changePassword == true {
                        self.navigateTo(viewController: PasswordViewController.self, withIdentifier: "PasswordViewController")
                        return
                    }
                }
                
                // otp while login (client requuirement)
                /*
                if let otpFlow = userdetails?["otp_flow"] as? Bool {
                    if otpFlow == true {
                        self.generateOTPApiCall()
                        return
                    }
                }
                */
                
                UserDefaults.standard.set(true, forKey: "IS_LOGGED_IN")
                self.navigateTo(viewController: DashboardViewController.self, withIdentifier: "DashboardViewController")
            } else {
                self.showAlert(self.viewModel.signInData?.message ?? "Invalid Token")
            }
        }
        
        viewModel.loadingStatus =
        {
            if self.viewModel.isLoading {
                if self.isFromSignIn {
                    self.activityIndicator(self.view, startAnimate: true)
                }
            } else {
                self.activityIndicator(self.view, startAnimate: false)
            }
        }
        viewModel.errorMessageAlert = {
            self.showAlert(self.viewModel.errorMessage ?? "")
        }
    }
    func generateOTPApiCall() {
        let params = [
            "email": UserDefaults.standard.string(forKey: "Email") ?? "",
            "username": UserDefaults.standard.string(forKey: "Username") ?? "",
            "mobile": "",
            "sms_type": "sms"
        ] as [String : Any]
         
        print("params \(params)")
        isFromSignIn = false
        viewModel.generateOTP(params: params)
        viewModel.generateOTPSuccess = { [self] in
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let popup = storyboard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
            if viewModel.generateOTPRes?.statuscode == 200 {
                popup.otpSentLabelText = self.viewModel.generateOTPRes?.message ?? ""
                popup.isFromSignIN = true
            } else {
                self.showAlert(self.viewModel.generateOTPRes?.message ?? "")
            }
            popup.modalPresentationStyle = .overCurrentContext
            present(popup, animated: true, completion: nil)
        }
        viewModel.errorMessageAlert = {
            self.showAlertWithHandler(message: self.viewModel.errorMessage ?? "Error",  okActionTitle: "Okay", enableCancel: false)
            {
                _ in
                
            }
        }
    }
    
    func googleAccountCheckApiCall(name:String,email:String, onboard:String)
    {
        let params = [
         "username": name,
         "email": email,
         "session_id": "",
         "onboarding" : onboard
        ] as [String : Any]
        
        
        print("params \(params)")
        
        viewModel.googleAuth(params: params)
        viewModel.signInSuccess =
        {
            
            if let token = self.viewModel.signInData?.data?.token {
                let userDetails = self.decodeJWT(part: token)
                UserDefaults.standard.set("Bearer \(self.viewModel.signInData?.data?.token ?? "")", forKey: "Authorization")
                UserDefaults.standard.set(userDetails?["patient_id"] ?? "Invalid ID", forKey: "PateintId")
                UserDefaults.standard.set(userDetails?["username"] ?? "Invalid name", forKey: "Username")
                UserDefaults.standard.set(userDetails?["profilePictureUrl"] ?? "Invalid img", forKey: "ProfileImg")
                UserDefaults.standard.set(userDetails?["email"] ?? "Invalid email", forKey: "Email")
                if(self.viewModel.signInData?.statuscode == 200)
                {
                    // already have the account
//                    self.navigateTo(viewController: DashboardViewController.self, withIdentifier: "DashboardViewController")
                    if let accessArray = userDetails?["has_access"] as? [Int] {
                        if !accessArray.contains(3) {
                            UserDefaults.standard.set(false, forKey: "IS_LOGGED_IN")
                            if let role = userDetails?["role"] as? Int {
                                self.displayLoginPopUpAdmin(role: role)
                            }
                            return
                        }
                    }
                    if let changePassword = userDetails?["change_pwd"] as? Bool {
                        if changePassword == true {
                            self.navigateTo(viewController: PasswordViewController.self, withIdentifier: "PasswordViewController")
                            return
                        }
                    }
                    if let otpFlow = userDetails?["otp_flow"] as? Bool {
                        if otpFlow == true {
                            self.generateOTPApiCall()
                            return
                        }
                    }
                    
                    UserDefaults.standard.set(true, forKey: "IS_LOGGED_IN")
                    self.navigateTo(viewController: DashboardViewController.self, withIdentifier: "DashboardViewController")
                }
                else
                {
                    //new account created
                    let jsonData: [String: Any] = [
                        "username": name,
                        "email": email,
                    ]
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: jsonData, options: [])
                        
                        // Deserialize JSON data into ProfileData model using JSONDecoder
                        let decoder = JSONDecoder()
                        let profile = try decoder.decode(ProfileData.self, from: jsonData)
                        let storyboard = UIStoryboard(name: "Main", bundle: .main)
                        let popup = storyboard.instantiateViewController(withIdentifier: "ProfileEditViewController") as! ProfileEditViewController
                        popup.userData = UserProfileData(data: profile)
                        popup.modalPresentationStyle = .overCurrentContext
                        self.present(popup, animated: true, completion: nil)
                        
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                    
                }

            } else
            {
                self.showAlert(self.viewModel.signInData?.message ?? "Invalid Token")
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
            self.showAlert(self.viewModel.errorMessage ?? "")
        }
    }
    
    func base64StringWithPadding(encodedString: String) -> String {
        var stringTobeEncoded = encodedString.replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let paddingCount = encodedString.count % 4
        for _ in 0..<paddingCount {
            stringTobeEncoded += "="
        }
        return stringTobeEncoded
    }

    func decodeJWT(part: String) -> [String: Any]?
    {
        let parts = part.components(separatedBy: ".")

        if parts.count != 3 { fatalError("jwt is not valid!") }
        let payload = parts[1]
        let payloadPaddingString = base64StringWithPadding(encodedString: payload)
        guard let payloadData = Data(base64Encoded: payloadPaddingString) else {
            fatalError("payload could not converted to data")
        }
        return try? JSONSerialization.jsonObject(
            with: payloadData,
            options: []) as? [String: Any]
    }
    func displayLoginPopUpAdmin(role: Int) {
        var roleName: String = "Admin"
        if role == 9 {
            roleName = "Super Admin"
        }
        let msg = "You are not authorized to access as you are \(roleName)."
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            self.dismiss(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
        return
        
    }

}
extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Phone Number
            if let userName = appleIDCredential.fullName {
                print("User Phone Number: \(userName)")
                if let email = appleIDCredential.email {
                    print("User Email: \(email)")
                }
            }
        }
        // Handle successful authorization
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        
        // Handle authorization error
    }
}

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // Return the window to which the authorization controller should be presented
        return self.view.window!
    }
}
