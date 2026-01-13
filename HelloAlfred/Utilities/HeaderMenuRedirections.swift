import UIKit

extension UIViewController:HeaderMenuViewDelegate {
   
    func ShowSOS() {
        makePhoneCall(phoneNumber: "1234567890")
    }
    
    func ShowHelp() {
        showAlert("This feature is coming soon.")
    }
    
    func ShowNotifications() {
        navigateTo(viewController: NotificationsViewController.self, withIdentifier: "NotificationsViewController")
    }
    
    func ShowProfile() {
        navigateTo(viewController: ProfileViewController.self, withIdentifier: "ProfileViewController")
    }
    
    func makePhoneCall(phoneNumber: String) {
        if let phoneURL = URL(string: "tel://\(phoneNumber)") {
            if UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            } else {
                // Show an alert if the phone call cannot be made
                print("This device cannot make phone calls.")
            }
        }
    }

}
