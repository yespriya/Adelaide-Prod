//
//  SignInResModel.swift
//  HelloAlfred
//
//  Created by admin on 02/04/24.
//

import Foundation
struct SigninResModel : Codable 
{
    let statuscode : Int?
    let status : Bool?
    let message : String?
    let data : UserData?

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
        data = try values.decodeIfPresent(UserData.self, forKey: .data)
    }

}
struct UserData : Codable {
    let token : String?

    enum CodingKeys: String, CodingKey {

        case token = "token"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }

}
