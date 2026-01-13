//
//  ChatStaticMessageModel.swift
//  HelloAlfred
//
//  Created by SS on 15/10/25.
//

import Foundation

struct ChatStaticMessageModel : Codable {
    let status : Bool?
    let statuscode : Int?
    let message : String?
    let data : WelcomeMessage?

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
        data = try values.decodeIfPresent(WelcomeMessage.self, forKey: .data)
    }

}

struct ChatPreferenceModel : Codable {
    let status : Bool?
    let statuscode : Int?
    let message : String?
}

struct WelcomeMessage : Codable {
    let message_type : String?
    let welcome_message : String?

    enum CodingKeys: String, CodingKey {

        case message_type = "message_type"
        case welcome_message = "welcome_message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message_type = try values.decodeIfPresent(String.self, forKey: .message_type)
        welcome_message = try values.decodeIfPresent(String.self, forKey: .welcome_message)
    }

}
