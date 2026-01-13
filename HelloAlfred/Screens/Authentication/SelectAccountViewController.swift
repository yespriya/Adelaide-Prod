//
//  SelectAccountViewController.swift
//  HelloAlfred
//
//  Created by admin on 28/02/24.
//

import UIKit

class SelectAccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signinClicked(_ sender: Any) {
      
        
        navigateTo(viewController: SignInViewController.self, withIdentifier: "SignInViewController")
    }
    @IBAction func patientClicked(_ sender: Any) {
        navigateTo(viewController: SignUpViewController.self, withIdentifier: "SignUpViewController")
    }
    
    @IBAction func physicianClicked(_ sender: Any) {
       showAlert("This feature is not available right soon!")
        
//        navigateTo(viewController: DoctorSignUpViewController.self, withIdentifier: "DoctorSignUpViewController")
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
