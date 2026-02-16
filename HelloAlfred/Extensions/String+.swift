//
//  String+.swift
//  Adelaide Prod
//
//  Created by Prit  on 14/02/26.
//

import Foundation

extension String {
    
    func toFormattedDate(
        inputFormat: String = "yyyy-MM-dd'T'HH:mm:ss",
        outputFormat: String = "MMM dd, yyyy"
    ) -> String {
        
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.dateFormat = inputFormat
        
        guard let date = inputFormatter.date(from: self) else {
            return self
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale.current
        outputFormatter.dateFormat = outputFormat
        
        return outputFormatter.string(from: date)
    }
}
