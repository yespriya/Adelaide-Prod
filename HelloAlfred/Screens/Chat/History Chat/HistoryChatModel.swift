
import Foundation
struct HistoryChatModel : Codable 
{
	let statuscode : Int?
	let status : Bool?
	let message : String?
	let data : [HistoryData]?

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
		data = try values.decodeIfPresent([HistoryData].self, forKey: .data)
	}

}

struct HistoryData : Codable {
    let ans_category : String?
    let type : String?
    let type_ : String?
    let description : String?
    let question_key : String?
    let options : [String]?

    enum CodingKeys: String, CodingKey {

        case ans_category = "ans_category"
        case type = "type"
        case type_ = "type_"
        case description = "description"
        case question_key = "question_key"
        case options = "options"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ans_category = try values.decodeIfPresent(String.self, forKey: .ans_category)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        type_ = try values.decodeIfPresent(String.self, forKey: .type_)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        question_key = try values.decodeIfPresent(String.self, forKey: .question_key)
        options = try values.decodeIfPresent([String].self, forKey: .options)
    }

}
