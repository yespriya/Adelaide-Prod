import UIKit

@IBDesignable
class ChipsView: UIView {

    // Array of strings representing the chips
    var chips: [String] = [] {
        didSet {
            setupChips()
        }
    }
    
    // Callback for chip tap action
    var chipTapped: ((String) -> Void)?
    
    private var totalHeight: CGFloat = 0
    
    // Set up the chips when the array is updated
    private func setupChips() {
        // Remove all existing chip buttons before adding new ones
        self.subviews.forEach { $0.removeFromSuperview() }
        
        var xPosition: CGFloat = 0
        var yPosition: CGFloat = 0
        let chipHeight: CGFloat = 30
        let maxWidth = self.frame.width - 20 // Leave some padding on both sides
        
        for chip in chips {
            let chipButton = UIButton(type: .system)
            chipButton.setTitle(chip, for: .normal)
            chipButton.backgroundColor = .clear // Transparent background
            chipButton.setTitleColor(.black, for: .normal)
            chipButton.layer.cornerRadius = 15
            chipButton.layer.borderWidth = 1 // Add border
            chipButton.layer.borderColor = UIColor.lightGray.cgColor // Light gray border
            chipButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            
            // Set the Poppins font with size 14
            chipButton.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 14)
            chipButton.titleLabel?.adjustsFontSizeToFitWidth = true
            chipButton.titleLabel?.minimumScaleFactor = 0.5
            chipButton.titleLabel?.lineBreakMode = .byTruncatingTail // Truncate with "..." if needed
            
            // Adjust button size based on content
            chipButton.sizeToFit()
            let chipWidth = min(chipButton.frame.width + 20, maxWidth) // Restrict chip width to maxWidth
            
            // Move to the next line if the chip exceeds the view width
            if xPosition + chipWidth > maxWidth {
                xPosition = 10
                yPosition += chipHeight + 10 // Move to the next row with some spacing
            }
            
            // Set the frame for the chip button
            chipButton.frame = CGRect(x: xPosition, y: yPosition, width: chipWidth, height: chipHeight)
            self.addSubview(chipButton)
            
            // Attach action to the chip button
            chipButton.addTarget(self, action: #selector(chipButtonTapped(_:)), for: .touchUpInside)
            
            // Store chip name for callback on tap
            chipButton.accessibilityLabel = chip
            
            xPosition += chipWidth + 10 // Move to the right for the next chip
        }
        
        // Calculate the total height based on the last yPosition
        totalHeight = yPosition + chipHeight + 10 // Add some padding at the bottom
        
        // Invalidate the intrinsic content size to recalculate the layout
        invalidateIntrinsicContentSize()
    }


    
    // Handle the chip button tap action
    @objc private func chipButtonTapped(_ sender: UIButton) {
        if let chipName = sender.accessibilityLabel {
            chipTapped?(chipName)
        }
    }

    // Override to provide the correct content size
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Reposition chips when the view layout changes
        setupChips()
    }
}

