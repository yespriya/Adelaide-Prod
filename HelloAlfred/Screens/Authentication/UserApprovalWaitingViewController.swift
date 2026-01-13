//
//  UserApprovalWaitingViewController.swift
//  HelloAlfred
//
//  Created by admin on 28/06/24.
//

import UIKit

class UserApprovalWaitingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func OKTapped(_ sender: Any) {        
        navigateTo(viewController: SignInViewController.self, withIdentifier: "SignInViewController")
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
