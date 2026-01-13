//
//  ChatModel.swift
//  HeloAlfredbotservice
//
//  Created by admin on 2/9/24.
//

import Foundation
struct ChatModel : Codable {
    let id : String?
    let object : String?
    let created : Int?
    let model : String?
    let choices : [Choices]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case object = "object"
        case created = "created"
        case model = "model"
        case choices = "choices"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        object = try values.decodeIfPresent(String.self, forKey: .object)
        created = try values.decodeIfPresent(Int.self, forKey: .created)
        model = try values.decodeIfPresent(String.self, forKey: .model)
        choices = try values.decodeIfPresent([Choices].self, forKey: .choices)
    }

}

struct Choices : Codable {
    let finish_reason : String?
    let index : Int?
    let message : MessageModel?

    enum CodingKeys: String, CodingKey {

        case finish_reason = "finish_reason"
        case index = "index"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        finish_reason = try values.decodeIfPresent(String.self, forKey: .finish_reason)
        index = try values.decodeIfPresent(Int.self, forKey: .index)
        message = try values.decodeIfPresent(MessageModel.self, forKey: .message)
    }

}


struct MessageModel : Codable {
    let role : String?
    let content : String?

    enum CodingKeys: String, CodingKey {

        case role = "role"
        case content = "content"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        role = try values.decodeIfPresent(String.self, forKey: .role)
        content = try values.decodeIfPresent(String.self, forKey: .content)
    }

}
