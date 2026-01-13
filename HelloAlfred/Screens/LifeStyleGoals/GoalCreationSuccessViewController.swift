//
//  GoalCreationSuccessViewController.swift
//  HelloAlfred
//
//  Created by admin on 15/04/24.
//

import UIKit

class GoalCreationSuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func OKPressed(_ sender: Any) {
        navigateTo(viewController: LifeStyleGoalDetailsViewController.self, withIdentifier: "LifeStyleGoalDetailsViewController")

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
