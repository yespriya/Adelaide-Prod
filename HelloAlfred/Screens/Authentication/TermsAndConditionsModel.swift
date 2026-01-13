
import Foundation
struct TermsAndConditionsModel : Codable {
	let statuscode : Int?
	let status : Bool?
	let message : String?
	let data : TermsAndConditionsData?

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
		data = try values.decodeIfPresent(TermsAndConditionsData.self, forKey: .data)
	}

}
struct TermsAndConditionsData : Codable {
    let result : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(String.self, forKey: .result)
    }

}
