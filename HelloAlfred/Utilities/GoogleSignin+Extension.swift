
import Foundation
import UIKit
import GoogleSignIn
import FirebaseCore
import FirebaseAuth



extension AppDelegate {
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let handled = GIDSignIn.sharedInstance.handle(url)
        
      return handled
    }
    
}

extension SignInViewController {
    func googleSignInAction()
    {
        
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
          guard error == nil else {
              
              return
            // ...
          }

            if let user = result?.user {
                let idToken = user.idToken?.tokenString ?? ""
                            let email = user.profile?.email
                               print("Signed in user's email: \(email ?? "No email found")  \(user.profile?.email)")
                
                googleAccountCheckApiCall(name: user.profile?.name ?? "", email: user.profile?.email ?? "", onboard: "google")

                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                               accessToken: user.accessToken.tokenString)
                           } else {
                               print("No user profile found")
                           }

//          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
//                                                         accessToken: user.accessToken.tokenString)

        }
    }
}
