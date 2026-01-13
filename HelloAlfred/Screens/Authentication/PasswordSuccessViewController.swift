//
//  PasswordSuccessViewController.swift
//  HelloAlfred
//
//  Created by admin on 11/03/24.
//

import UIKit
class PasswordSuccessViewController: UIViewController 
{
    var fromSignup = true;
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func continueClicked(_ sender: Any) {
        
        if(fromSignup)
        {
            navigateTo(viewController: UserApprovalWaitingViewController.self, withIdentifier: "UserApprovalWaitingViewController")
        }
        else
        {            
            navigateTo(viewController: SignInViewController.self, withIdentifier: "SignInViewController")
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
