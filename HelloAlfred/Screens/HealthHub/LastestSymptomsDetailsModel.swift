
import Foundation
struct LastestSymptomsDetailsModel : Codable {
	let statuscode : Int?
	let status : Bool?
	let message : String?
	let data : [SymptomsDetailsData]?

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
		data = try values.decodeIfPresent([SymptomsDetailsData].self, forKey: .data)
	}

}

struct SymptomsDetailsData : Codable {
    let severity : String?
    let frequency : String?
    let quality_of_life : String?
    let symptoms_key : String?

    enum CodingKeys: String, CodingKey {

        case severity = "severity"
        case frequency = "frequency"
        case quality_of_life = "quality_of_life"
        case symptoms_key = "symptoms_key"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        severity = try values.decodeIfPresent(String.self, forKey: .severity)
        frequency = try values.decodeIfPresent(String.self, forKey: .frequency)
        quality_of_life = try values.decodeIfPresent(String.self, forKey: .quality_of_life)
        symptoms_key = try values.decodeIfPresent(String.self, forKey: .symptoms_key)
    }

}
