//
//  SubscriptionCollectionViewCell.swift
//  HelloAlfred
//
//  Created by admin on 08/03/24.
//

import UIKit

class SubscriptionCollectionViewCell: UICollectionViewCell {
    @IBOutlet var subscriptionTypeLabel: UILabel!
    
    @IBOutlet var bgView: Myview!
    @IBOutlet var selectionButton: UIButton!
    @IBOutlet var featureListTableView: UITableView!
    
    var featureList: [FeatureData] = []
    var planSelectionButtonTappedHandler: (() -> Void)?

    
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        featureListTableView.register(UINib(nibName: "FeatureListTableViewCell", bundle: .main), forCellReuseIdentifier: "FeatureListTableViewCell")
        
        featureListTableView.delegate = self;
        featureListTableView.dataSource = self;
        
        // Initialization code
    }
    @IBAction func planSelectionTapped(_ sender: Any) 
    {
        planSelectionButtonTappedHandler?();
    }
    
}
extension SubscriptionCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return featureList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureListTableViewCell") as! FeatureListTableViewCell
        cell.featureLabel.text = featureList[indexPath.row].feature
        
        if(featureList[indexPath.row].availability)
        {
            cell.availabilityImage.image = UIImage(named: "available")
        }
        else
        {
            cell.availabilityImage.image = UIImage(named: "unavailable")
        }
       
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 28
    }
    // Implement UITableViewDelegate and UITableViewDataSource methods
    // ...
}
struct FeatureData{
    let feature:String;
    let availability:Bool
}
