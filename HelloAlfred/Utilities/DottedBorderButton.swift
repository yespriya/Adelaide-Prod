import UIKit

class DottedBorderButton: UIButton {

    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addDottedBorder()
    }

    private func addDottedBorder() {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = tintColor.cgColor
        borderLayer.lineDashPattern = [2, 2] // Adjust the values to change the size of the dashes and gaps.
        borderLayer.frame = bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath

        layer.addSublayer(borderLayer)
    }
}

