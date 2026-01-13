//
//  FeatureListTableViewCell.swift
//  HelloAlfred
//
//  Created by admin on 08/03/24.
//

import UIKit

class FeatureListTableViewCell: UITableViewCell {

    @IBOutlet var availabilityImage: UIImageView!
    @IBOutlet var featureLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
