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
    
    var introData = [IntroData(introImage: UIImage(named: "intro1")!, title: "Keep your health", description: "Considers the as-is state and the vital health info of the patient and suggests an optimal path for better health"),
         IntroData(introImage: UIImage(named: "intro2")!, title: "Intelligent Prompts", description: "Provides the patient with intelligent prompts and sends behavioral nudges to motivate and continue to hit the key milestones in their better well-being journey."),
        IntroData(introImage: UIImage(named: "intro3")!, title: "Let’s monitor", description: "Collects data over a period and displays the patient’s journey outcomes by analyzing information from well-being/health apps, change of lifestyle,")];
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func nextClicked(_ sender: Any) {
            skipCount+=1
            if(skipCount > 2)
            {
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                let popup = storyboard.instantiateViewController(withIdentifier: "SelectAccountViewController") as! SelectAccountViewController
              
                popup.modalPresentationStyle = .overCurrentContext
                present(popup, animated: true, completion: nil)
            }
        else
        {
            introImage.image = introData[skipCount].introImage
            introTitle.text = introData[skipCount].title
            introDescription.text = introData[skipCount].description
        }
         
    }
    
    @IBAction func skipClicked(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let popup = storyboard.instantiateViewController(withIdentifier: "SelectAccountViewController") as! SelectAccountViewController
      
        popup.modalPresentationStyle = .overCurrentContext
        present(popup, animated: true, completion: nil)
    }
}


struct IntroData
{
    var introImage: UIImage
    var title: String
    var description: String
}
