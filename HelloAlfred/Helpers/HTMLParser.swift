//
//  HTMLParser.swift
//  HelloAlfred
//
//  Created by Prit on 25/12/25.
//

import SwiftSoup
import Foundation

struct HTMLParser {
    static func parseMedicationContent(html: String, divId: String) -> NSAttributedString? {
        do {
            let doc = try SwiftSoup.parse(html)
            guard let div = try doc.select("div#\(divId)").first() else { return nil }
            
            // Convert HTML to attributed string
            let htmlContent = try div.html()
            return try NSAttributedString(
                data: Data(htmlContent.utf8),
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
        } catch {
            print("HTML parsing error: \(error)")
            return nil
        }
    }
}
