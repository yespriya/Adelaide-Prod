import Foundation

struct QuestionUpdateResModel : Codable {
	let status_code : Int?
	let message : String?
	let data : QuestionResData?

	enum CodingKeys: String, CodingKey {

		case status_code = "statuscode"
		case message = "message"
		case data = "data"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		data = try values.decodeIfPresent(QuestionResData.self, forKey: .data)
	}

}
struct QuestionResData : Codable 
{
    let alfred : String?
    let user : String?

    enum CodingKeys: String, CodingKey {

        case alfred = "Alfred"
        case user = "User"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        alfred = try values.decodeIfPresent(String.self, forKey: .alfred)
        user = try values.decodeIfPresent(String.self, forKey: .user)
    }

}
