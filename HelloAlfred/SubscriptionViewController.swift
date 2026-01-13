//
//  SubscriptionViewController.swift
//  HelloAlfred
//
//  Created by admin on 08/03/24.
//

import UIKit

class SubscriptionViewController: UIViewController{
    

    @IBOutlet var continueButton: Mybutton!
    @IBOutlet var plansCollectionView: UICollectionView!
    var selectedPlanIndex = -1;

    var basicFeatureList = [FeatureData(feature: "Patient Registration", availability: true),
                            FeatureData(feature: "Avatar Customization", availability: true),
                            FeatureData(feature: "Chat", availability: true),FeatureData(feature: "Connect with wearables", availability: true),FeatureData(feature: "Access Knowledge base", availability: true),FeatureData(feature: "Referral Option", availability: true),FeatureData(feature: "Real-time sentiment capture", availability: true),FeatureData(feature: "Ambient listening", availability: true),FeatureData(feature: "Goal setting", availability: false),
                            FeatureData(feature: "Goal tracking", availability: false),FeatureData(feature: "Dashboards", availability: false),FeatureData(feature: "Widgets", availability: false),
                            FeatureData(feature: "Physician Consultation", availability: false),FeatureData(feature: "Journey Enhancements", availability: false),FeatureData(feature: "Third party vendor interfaces", availability: false)
    ];
    var standardFeatureList = [FeatureData(feature: "Patient Registration", availability: true),FeatureData(feature: "Avatar Customization", availability: true),
                            FeatureData(feature: "Chat", availability: true),FeatureData(feature: "Connect with wearables", availability: true),FeatureData(feature: "Access Knowledge base", availability: true),FeatureData(feature: "Referral Option", availability: true),FeatureData(feature: "Real-time sentiment capture", availability: true),FeatureData(feature: "Ambient listening", availability: true),FeatureData(feature: "Goal setting", availability: true),
                            FeatureData(feature: "Goal tracking", availability: true),FeatureData(feature: "Dashboards", availability: true),FeatureData(feature: "Widgets", availability: true),
                            FeatureData(feature: "Physician Consultation", availability: true),FeatureData(feature: "Journey Enhancements", availability: false),FeatureData(feature: "Third party vendor interfaces", availability: false)
    ];
    var premiumFeatureList = [FeatureData(feature: "Patient Registration", availability: true),FeatureData(feature: "Avatar Customization", availability: true),
                            FeatureData(feature: "Chat", availability: true),FeatureData(feature: "Connect with wearables", availability: true),FeatureData(feature: "Access Knowledge base", availability: true),FeatureData(feature: "Referral Option", availability: true),FeatureData(feature: "Real-time sentiment capture", availability: true),FeatureData(feature: "Ambient listening", availability: true),FeatureData(feature: "Goal setting", availability: true),
                            FeatureData(feature: "Goal tracking", availability: true),FeatureData(feature: "Dashboards", availability: true),FeatureData(feature: "Widgets", availability: true),
                            FeatureData(feature: "Physician Consultation", availability: true),FeatureData(feature: "Journey Enhancements", availability: true),FeatureData(feature: "Third party vendor interfaces", availability: true)
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plansCollectionView.register(UINib(nibName: "SubscriptionCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "SubscriptionCollectionViewCell")
        plansCollectionView.delegate = self;
        plansCollectionView.dataSource = self;
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func continueClicked(_ sender: Any) {
        
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let popup = storyboard.instantiateViewController(withIdentifier: "PaymentOptionsViewController") as! PaymentOptionsViewController
            
            popup.modalPresentationStyle = .overCurrentContext
            present(popup, animated: true, completion: nil)
       
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
extension SubscriptionViewController:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionCollectionViewCell", for: indexPath) as! SubscriptionCollectionViewCell
               // Configure the cell with data if needed
        switch indexPath.row
        {
        case 0:
            cell.featureList = basicFeatureList
            cell.bgView.backgroundColor = UIColor(named: "BasicBG")
        case 1:
            cell.featureList = standardFeatureList
            cell.bgView.backgroundColor = UIColor(named: "StandardBG")
        case 2:
            cell.featureList = premiumFeatureList
            cell.bgView.backgroundColor = UIColor(named: "PremiumBG")
        default:
            cell.featureList = basicFeatureList
            cell.bgView.backgroundColor = UIColor(named: "BasicBG")

        }
        cell.planSelectionButtonTappedHandler = {
            self.continueButton.isEnabled = true;
            self.continueButton.backgroundColor = UIColor(named: "AppTheme")
            
            self.selectedPlanIndex = indexPath.row
            self.plansCollectionView.reloadData()
        }
        
        print("dttt \(self.selectedPlanIndex)")
        if(self.selectedPlanIndex == indexPath.row)
        {
            cell.selectionButton.setImage(UIImage(named: "radio-selected"), for: .normal)
        }
        else
        {
            cell.selectionButton.setImage(UIImage(named: "radio-unselected"), for: .normal)
        }
        return cell
    }
    
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height = plansCollectionView.frame.size.height;
        var width = plansCollectionView.frame.size.width;

        return CGSize(width: width, height: height)
    }
}
