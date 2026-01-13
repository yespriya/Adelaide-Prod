//
//  SignInViewController.swift
//  HelloAlfred
//
//  Created by admin on 14/03/24.
//

import UIKit
import AuthenticationServices
import GoogleSignIn

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      //  GIDSignIn.sharedInstance.presentingViewController = self
      //  GIDSignIn.sharedInstance().delegate = self

        // Do any additional setup after loading the view.
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
    @IBAction func googleLoginClicked(_ sender: Any)
    {
        googleSignInAction()
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
extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Email
            
            print("app \(appleIDCredential.user)")
            if let email = appleIDCredential.email {
                print("User Email: \(email)")
            }
            
            // Phone Number
            if let phoneNumber = appleIDCredential.fullName {
                print("User Phone Number: \(phoneNumber)")
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
