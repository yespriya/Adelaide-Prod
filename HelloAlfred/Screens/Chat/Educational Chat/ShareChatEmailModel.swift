//
//  ShareChatEmail.swift
//  HelloAlfred
//
//  Created by SS on 06/09/25.
//

import Foundation
struct ShareChatEmail : Codable {
    let status : Bool?
    let statuscode : Int?
    let message : String?
    let data : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case statuscode = "statuscode"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        statuscode = try values.decodeIfPresent(Int.self, forKey: .statuscode)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(String.self, forKey: .data)
    }

}
