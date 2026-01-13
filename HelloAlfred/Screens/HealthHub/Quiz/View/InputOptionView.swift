//
//  InputOptionView.swift
//  HelloAlfred
//
//  Created by SS on 08/08/25.
//

import UIKit

class InputOptionView: UIView {
    
    @IBOutlet weak var tvAnswerHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var tvAnswers: UITextView!
    @IBOutlet var contentView: UIView!
    
    private var placeholderLabel: UILabel!
    private let minHeight: CGFloat = 100
    
    // Closure to notify parent view/controller about text changes
    var onTextChanged: ((String) -> Void)?
    
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
        updateHeight()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("InputOptionView", owner: self)
        contentView.fixInView(self)
        
        setupTextView()
        setupPlaceholder()
    }
    
    private func setupTextView() {
        tvAnswers.delegate = self
        tvAnswers.isScrollEnabled = false // we handle height ourselves
    }
    
    private func setupPlaceholder() {
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter your answer..."
        placeholderLabel.font = tvAnswers.font
        placeholderLabel.textColor = .lightGray
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        tvAnswers.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: tvAnswers.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: tvAnswers.leadingAnchor, constant: 5),
            placeholderLabel.trailingAnchor.constraint(equalTo: tvAnswers.trailingAnchor, constant: -5)
        ])
    }
    
    private func updateHeight() {
        let size = CGSize(width: tvAnswers.frame.width, height: .infinity)
        let estimatedSize = tvAnswers.sizeThatFits(size)
        let newHeight = max(minHeight, estimatedSize.height)
        tvAnswerHeightAnchor.constant = newHeight
        layoutIfNeeded()
    }
}

// MARK: - UITextViewDelegate

extension InputOptionView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateHeight()
        placeholderLabel.isHidden = !textView.text.isEmpty
        onTextChanged?(textView.text)
    }
}
