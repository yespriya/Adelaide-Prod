//
//  ScaleOptionView.swift
//  HelloAlfred
//
//  Created by SS on 08/08/25.
//

import UIKit

class ScaleOptionView: UIView {

    @IBOutlet weak var sliderView: UISlider!
    @IBOutlet weak var valueLabel: UILabel! // shows "Test1", etc.
    @IBOutlet weak var labelsStackView: UIStackView!
    @IBOutlet var contentView: UIView!

    var labelMap: [String: String] = [:] {
        didSet {
            setupScaleLabels()
        }
    }

    var onValueChanged: ((Int, String) -> Void)?
    var onValueChangedEnd: ((Int, String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("ScaleOptionView", owner: self, options: nil)
        contentView.fixInView(self)
        
        if let heartImage = UIImage(named: "ic_heart_fill")?.resized(to: CGSize(width: 30, height: 30)) {
            sliderView.setThumbImage(heartImage, for: .normal)
            sliderView.setThumbImage(heartImage, for: .highlighted)
        }
        sliderView.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        sliderView.addTarget(self, action: #selector(sliderChangedEnded), for: [[.touchUpInside, .touchUpOutside, .touchCancel]])
    }

    private func setupScaleLabels() {
        labelsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Sort keys numerically
        let sortedKeys = labelMap.keys.compactMap { Int($0) }.sorted()
        guard let min = sortedKeys.first, let max = sortedKeys.last else { return }

        sliderView.minimumValue = Float(min)
        sliderView.maximumValue = Float(max)
        sliderView.setValue(Float(min), animated: false)

        // Add labels below slider
        for (index, key) in sortedKeys.enumerated() {
            let label = UILabel()
            label.text = "\(key)"
            label.font = .systemFont(ofSize: 12)

            if index == 0 {
                label.textAlignment = .left
            } else if index == sortedKeys.count - 1 {
                label.textAlignment = .right
            } else {
                label.textAlignment = .center
            }

            label.setContentHuggingPriority(.defaultLow, for: .horizontal)
            label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

            labelsStackView.addArrangedSubview(label)
        }
        
        updateValueLabel(for: min)
    }

    @objc private func sliderChanged() {
        let rawValue = sliderView.value
        let roundedValue = Int(round(rawValue))
        sliderView.setValue(Float(roundedValue), animated: false)

        updateValueLabel(for: roundedValue)
        onValueChanged?(roundedValue, labelMap["\(roundedValue)"] ?? "")
    }
    
    @objc func sliderChangedEnded() {
        let rawValue = sliderView.value
        let roundedValue = Int(round(rawValue))
        sliderView.setValue(Float(roundedValue), animated: false)

        updateValueLabel(for: roundedValue)
        onValueChangedEnd?(roundedValue, labelMap["\(roundedValue)"] ?? "")
    }

    private func updateValueLabel(for value: Int) {
        valueLabel.text = labelMap["\(value)"]
    }
    
    // Programmatically set selected value and update UI
    func setSelectedValue(_ value: Int, shouldSendCallback: Bool = false) {
        // clamp to slider range
        let minValue = Int(sliderView.minimumValue)
        let maxValue = Int(sliderView.maximumValue)
        let clamped = max(minValue, min(maxValue, value))

        sliderView.setValue(Float(clamped), animated: false)
        updateValueLabel(for: clamped)

        // optionally call onValueChanged to notify parent (default false)
        if shouldSendCallback {
            onValueChanged?(clamped, labelMap["\(clamped)"] ?? "")
        }
    }

}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result ?? self
    }
}
