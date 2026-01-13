
import Foundation
struct LinearChartDataModel : Codable {
	let statuscode : Int?
	let status : Bool?
	let message : String?
	let data : [LinearChartDetailsData]?

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
		data = try values.decodeIfPresent([LinearChartDetailsData].self, forKey: .data)
	}

}


struct LinearChartDetailsData : Codable {
    let tdate : String?
    let weight : String?
    let systolic_p : Int?
    let diastolic_p : Int?
    let pulse : String?

    enum CodingKeys: String, CodingKey {

        case tdate = "tdate"
        case weight = "weight"
        case systolic_p = "systolic_p"
        case diastolic_p = "diastolic_p"
        case pulse = "pulse"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        tdate = try values.decodeIfPresent(String.self, forKey: .tdate)
        weight = try values.decodeIfPresent(String.self, forKey: .weight)
        systolic_p = try values.decodeIfPresent(Int.self, forKey: .systolic_p)
        diastolic_p = try values.decodeIfPresent(Int.self, forKey: .diastolic_p)
        pulse = try values.decodeIfPresent(String.self, forKey: .pulse)
    }

}
