
import Foundation
struct ProfileCompletionModel : Codable {
	let statuscode : Int?
	let status : Bool?
	let message : String?
	let data : ProfileCompletionData?

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
		data = try values.decodeIfPresent(ProfileCompletionData.self, forKey: .data)
	}

}

struct ProfileCompletionData : Codable {
    let reached_75_percent : Bool?
    let profile_percent : Int?
    let history_progress_criteria : Bool?
    let redirection_key : String?

    enum CodingKeys: String, CodingKey {

        case reached_75_percent = "reached_75_percent"
        case profile_percent = "profile_percent"
        case history_progress_criteria = "history_progress_criteria"
        case redirection_key = "redirection_key"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        reached_75_percent = try values.decodeIfPresent(Bool.self, forKey: .reached_75_percent)
        profile_percent = try values.decodeIfPresent(Int.self, forKey: .profile_percent)
        history_progress_criteria = try values.decodeIfPresent(Bool.self, forKey: .history_progress_criteria)
        redirection_key = try values.decodeIfPresent(String.self, forKey: .redirection_key)

    }

}
