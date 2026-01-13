//
//  ViewController.swift
//  HelloAlfred
//
//  Created by admin on 26/02/24.
//

import UIKit

class AppIntroViewController: UIViewController {
    
    @IBOutlet var introImage: UIImageView!
    @IBOutlet var introDescription: UILabel!
    
    @IBOutlet var introTitle: UILabel!
    
    var skipCount = 0;
    
    var introData = [IntroData(introImage: UIImage(named: "app-intro-icon1")!, title: "Keep your health", description: "Considers the as-is state and the vital health info of the patient and suggests an optimal path for better health"),
         IntroData(introImage: UIImage(named: "app-intro-icon2")!, title: "Intelligent Prompts", description: "Provides the patient with intelligent prompts and sends behavioral nudges to motivate and continue to hit the key milestones in their better well-being journey."),
        IntroData(introImage: UIImage(named: "app-intro-icon3")!, title: "Let’s monitor", description: "Collects data over a period and displays the patient’s journey outcomes by analyzing information from well-being/health apps, change of lifestyle,")];
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    @IBAction func nextClicked(_ sender: Any) {
            skipCount+=1
            if(skipCount > 2)
            {
                navigateTo(viewController: SelectAccountViewController.self, withIdentifier: "SelectAccountViewController")
            }
        else
        {
            introImage.image = introData[skipCount].introImage
            introTitle.text = introData[skipCount].title
            introDescription.text = introData[skipCount].description
        }
         
    }
    
    @IBAction func skipClicked(_ sender: Any) {
                navigateTo(viewController: SelectAccountViewController.self, withIdentifier: "SelectAccountViewController")
    }
}



