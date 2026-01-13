//
//  CommonView.swift
//  HelloAlfred
//
//  Created by SS on 13/07/25.
//

import UIKit

extension UIView {

    @IBInspectable var VcornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var VborderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var VborderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    /// Makes the view perfectly circular based on its width and height.
    @IBInspectable var VisCircular: Bool {
        get {
            return layer.cornerRadius == min(bounds.width, bounds.height) / 2
        }
        set {
            if newValue {
                let minSide = min(bounds.width, bounds.height)
                layer.cornerRadius = minSide / 2
                layer.masksToBounds = true
            }
        }
    }
}
