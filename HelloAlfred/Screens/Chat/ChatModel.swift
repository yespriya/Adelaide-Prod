import Foundation
struct ChatModel : Codable {
    let statuscode : Int?
    let status : Bool?
    let message : String?
    let data : ChatData?

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
        data = try values.decodeIfPresent(ChatData.self, forKey: .data)
    }

}

struct ChatData : Codable {
    let user : String?
    let alfred : String?

    enum CodingKeys: String, CodingKey {

        case user = "user"
        case alfred = "alfred"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user = try values.decodeIfPresent(String.self, forKey: .user)
        alfred = try values.decodeIfPresent(String.self, forKey: .alfred)
    }

}
