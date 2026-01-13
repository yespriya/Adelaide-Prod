//
//  HealthHubDropDownModel.swift
//  HelloAlfred
//
//  Created by SS on 14/07/25.
//

import Foundation

struct HealthHubDropDownModel : Codable {
    let statuscode : Int?
    let status : Bool?
    let message : String?
    let data : [HealthHubDropDownData]?

    enum CodingKeys: String, CodingKey {

        case statuscode = "statuscode"
        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statuscode = try values.decodeIfPresent(Int.self, forKey: .statuscode)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([HealthHubDropDownData].self, forKey: .data)
    }

}

struct HealthHubDropDownData : Codable {
    let value : String?
    let label : String?
    let quizKey : String?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case value = "value"
        case label = "label"
        case quizKey = "quizKey"
        case title = "title"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        label = try values.decodeIfPresent(String.self, forKey: .label)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        quizKey = try values.decodeIfPresent(String.self, forKey: .quizKey)
    }

}
