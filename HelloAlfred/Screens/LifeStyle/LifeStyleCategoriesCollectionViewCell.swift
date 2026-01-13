import UIKit

class LifeStyleCategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var filledViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var filledView: UIView!
    @IBOutlet var unFilledView: UIView!
    @IBOutlet var subTitleSpaceConstraint: NSLayoutConstraint!
    @IBOutlet var subTitleUnitLabel: UILabel!
    @IBOutlet var bgView: Myview!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var categoryImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initial setup can be done here if needed
    }
    
    /// Updates the multiplier of the filled view's height constraint
    func updateFilledViewHeightMultiplier(_ multiplier: CGFloat) {
        // Ensure the filledViewHeightConstraint is not nil
        if let filledViewHeightConstraint = filledViewHeightConstraint {
            let newConstraint = filledViewHeightConstraint.constraintWithMultipliers(multiplier)
            
            // Replace the constraint on the cell's contentView
            self.contentView.removeConstraint(filledViewHeightConstraint)
            self.contentView.addConstraint(newConstraint)
            
            // Update the property reference
            self.filledViewHeightConstraint = newConstraint
            
            // Refresh layout
            self.contentView.layoutIfNeeded()
        }
    }
}

