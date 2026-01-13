

import UIKit

class SideMenuViewCell: UITableViewCell {

    @IBOutlet var betaView: Myview!
    @IBOutlet var titleIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        configureText(selected: false)
    }
    
    func configureText(selected:Bool) {
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
