
import UIKit

class goalCategoriesTableViewCell: UITableViewCell {

    @IBOutlet var radioButton: UIButton!
    @IBOutlet var bgView: Myview!
    @IBOutlet var categoriesLabel: UILabel!
    var radioButtonTappedHandler: (() -> Void)?

    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    @IBAction func radioButtonTapped(_ sender: Any) {
        radioButtonTappedHandler?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
