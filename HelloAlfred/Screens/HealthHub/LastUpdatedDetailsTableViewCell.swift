//
//  LastUpdatedDetailsTableViewCell.swift
//  HelloAlfred
//
//  Created by admin on 10/09/24.
//

import UIKit

class LastUpdatedDetailsTableViewCell: UITableViewCell {

    @IBOutlet var details4Label: UILabel!
    @IBOutlet var details3Label: UILabel!
    @IBOutlet var details2Label: UILabel!
    @IBOutlet var details1Label: UILabel!
    @IBOutlet var title1Label: UILabel!
    @IBOutlet var title2Label: UILabel!
    @IBOutlet var title3Label: UILabel!
    @IBOutlet var title4Label: UILabel!
    @IBOutlet var bgView: Myview!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
