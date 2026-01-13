import Foundation
struct HistoryTranscriptModel : Codable {
	let statuscode : Int?
	let status : Bool?
	let message : String?
	let data : TranscriptData?

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
		data = try values.decodeIfPresent(TranscriptData.self, forKey: .data)
	}

}
struct TranscriptData : Codable {
    let patient_info : String?

    enum CodingKeys: String, CodingKey {

        case patient_info = "patient_info"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        patient_info = try values.decodeIfPresent(String.self, forKey: .patient_info)
    }

}
