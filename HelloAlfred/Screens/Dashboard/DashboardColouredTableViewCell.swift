//
//  DashboardColouredTableViewCell.swift
//  HelloAlfred
//
//  Created by admin on 17/05/24.
//

import UIKit

class DashboardColouredTableViewCell: UITableViewCell {

    @IBOutlet var bgViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var bgWidthContraint: NSLayoutConstraint!
    @IBOutlet var bgView: LeadingRoundedCornerView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var initialLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
