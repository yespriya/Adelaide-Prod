//
//  HealthHubOverviewTableViewCell.swift
//  HelloAlfred
//
//  Created by admin on 03/08/24.
//

import UIKit

class HealthHubOverviewTableViewCell: UITableViewCell {
    
    @IBOutlet var weekLabel: UILabel!
    @IBOutlet var containerView: Myview!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detail1Label: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.shadowRadius = 5
        containerView.layer.shadowOpacity = 0.6
        containerView.layer.shadowOffset = CGSize(width: 3, height: 1)
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.masksToBounds = false
    }
}
