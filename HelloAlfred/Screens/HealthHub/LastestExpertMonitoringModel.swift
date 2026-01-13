import Foundation
struct LastestExpertMonitoringModel : Codable {
	let statuscode : Int?
	let status : Bool?
	let message : String?
	let data : LastestExpertMonitoringData?

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
		data = try values.decodeIfPresent(LastestExpertMonitoringData.self, forKey: .data)
	}

}
struct LastestExpertMonitoringData : Codable {
    let feet : String?
    let weight : String?
    let bloodp : String?
    let pulse : String?

    enum CodingKeys: String, CodingKey {

        case feet = "feet"
        case weight = "weight"
        case bloodp = "bloodp"
        case pulse = "pulse"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        feet = try values.decodeIfPresent(String.self, forKey: .feet)
        weight = try values.decodeIfPresent(String.self, forKey: .weight)
        bloodp = try values.decodeIfPresent(String.self, forKey: .bloodp)
        pulse = try values.decodeIfPresent(String.self, forKey: .pulse)
    }

}
