//
//  WeekSelectionTableViewCell.swift
//  HelloAlfred
//
//  Created by admin on 03/08/24.
//

import UIKit

class WeekSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var blurView: UIView!
    @IBOutlet var weekLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
