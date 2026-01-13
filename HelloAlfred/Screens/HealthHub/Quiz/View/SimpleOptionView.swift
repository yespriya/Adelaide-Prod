//
//  SimpleOptionView.swift
//  HelloAlfred
//
//  Created by SS on 07/08/25.
//

import UIKit

class SimpleOptionView: UIView {
    
    @IBOutlet weak var imgCheckBoxButton: UIImageView!
    @IBOutlet weak var lblOption: UILabel!
    @IBOutlet weak var imgRadioButton: UIImageView!
    @IBOutlet weak var btnOption: UIButton!
    @IBOutlet var contentView: UIView!
    
    var isMultipleOption: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    var isSelectedOption: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("SimpleOptionVIew", owner: self)
        contentView.fixInView(self)
    }
    
    private func updateUI() {
        // Show/hide based on multiple/single selection
        imgCheckBoxButton.isHidden = !isMultipleOption
        imgRadioButton.isHidden = isMultipleOption
        
        // Update image and label color based on selection
        if isMultipleOption {
            imgCheckBoxButton.image = isSelectedOption ? UIImage(named: "ic_check_mark") : UIImage(systemName: "square")
            imgCheckBoxButton.tintColor = isSelectedOption ? .systemTeal : .black
        } else {
            imgRadioButton.image = UIImage(systemName: isSelectedOption ? "circle.inset.filled" : "circle")
            imgRadioButton.tintColor = isSelectedOption ? .systemTeal : .black
        }
        
        // Update label color
        lblOption.textColor = isSelectedOption ? .systemTeal : .black
        
    }
}
