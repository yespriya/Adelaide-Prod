//
//  Struct+.swift
//  HelloAlfred
//
//  Created by Prit on 29/12/25.
//

import Foundation

extension Encodable {
    func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let json = try? JSONSerialization.jsonObject(with: data, options: []),
              let dictionary = json as? [String: Any] else {
            return [:]
        }
        return dictionary
    }
}
