//
//  Label+.swift
//  HelloAlfred
//
//  Created by Prit on 25/12/25.
//

import UIKit

extension UILabel {
    func setHTMLText(_ text: String, defaultFont: UIFont = UIFont.systemFont(ofSize: 14), defaultColor: UIColor = .black) {
        // Detect if text contains HTML-like tags
        let isHTML = text.contains("<") && text.contains(">")

        if isHTML {
            if let data = text.data(using: .utf8) {
                let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ]
                
                if let attributedString = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil) {
                    
                    // Apply default font & color to whole string
                    let fullRange = NSRange(location: 0, length: attributedString.length)
                    attributedString.addAttribute(.font, value: defaultFont, range: fullRange)
                    attributedString.addAttribute(.foregroundColor, value: defaultColor, range: fullRange)
                    
                    self.attributedText = attributedString
                    return
                }
            }
        }
        
        // Fallback: plain text
        self.text = text
        self.font = defaultFont
        self.textColor = defaultColor
    }
}
