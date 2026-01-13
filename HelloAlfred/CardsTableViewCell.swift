//
//  CardsTableViewCell.swift
//  FirstPass
//
//  Created by Skeintech on 22/06/21.
//  Copyright © 2021 Sathishkumar Muthukumar. All rights reserved.
//

import UIKit

class CardsTableViewCell: UITableViewCell
{

    @IBOutlet var radioImage: UIImageView!
    @IBOutlet var bankNameLabel: UILabel!
    @IBOutlet var bankImage: UIImageView!
    @IBOutlet var cardnumberLabel: UILabel!
    var cardSelectionButtonTappedHandler: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func radioClicked(_ sender: Any) 
    {
        cardSelectionButtonTappedHandler?()
    }
}
