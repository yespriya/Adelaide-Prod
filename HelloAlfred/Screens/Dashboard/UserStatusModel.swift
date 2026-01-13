import Foundation
struct UserStatusModel : Codable {
	let statuscode : Int?
	let status : Bool?
	let message : String?
	let data : StatusData?

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
		data = try values.decodeIfPresent(StatusData.self, forKey: .data)
	}

}
struct StatusData : Codable {
    let health_hub : Int?
    let lifestyle_goals : Int?
    let expert_monitoring : Int?
    let list_your_symptoms : Int?
    let optimal_risk_managemment : Int?

    enum CodingKeys: String, CodingKey {

        case health_hub = "health_hub"
        case lifestyle_goals = "lifestyle_goals"
        case expert_monitoring = "expert_monitoring"
        case list_your_symptoms = "list_your_symptoms"
        case optimal_risk_managemment = "optimal_risk_managemment"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        health_hub = try values.decodeIfPresent(Int.self, forKey: .health_hub)
        lifestyle_goals = try values.decodeIfPresent(Int.self, forKey: .lifestyle_goals)
        expert_monitoring = try values.decodeIfPresent(Int.self, forKey: .expert_monitoring)
        list_your_symptoms = try values.decodeIfPresent(Int.self, forKey: .list_your_symptoms)
        optimal_risk_managemment = try values.decodeIfPresent(Int.self, forKey: .optimal_risk_managemment)
    }

}
