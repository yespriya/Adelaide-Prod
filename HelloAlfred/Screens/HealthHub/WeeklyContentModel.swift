
import Foundation

struct WeeklyContentModel : Codable {
	let statuscode : Int?
	let status : Bool?
	let message : String?
	let data : HealthData?

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
		data = try values.decodeIfPresent(HealthData.self, forKey: .data)
	}

}

struct HealthData : Codable {
    let week_title : String?
    let week_desc : String?
    let week_objective : String?
    let week_explanation : String?
    let week_activity : String?
    let content : [WeeklyContent]?

    enum CodingKeys: String, CodingKey {

        case week_title = "week_title"
        case week_desc = "week_desc"
        case content = "content"
        case week_objective = "week_objective"
        case week_explanation = "week_explanation"
        case week_activity = "week_activity"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        week_title = try values.decodeIfPresent(String.self, forKey: .week_title)
        week_desc = try values.decodeIfPresent(String.self, forKey: .week_desc)
        week_objective = try values.decodeIfPresent(String.self, forKey: .week_objective)
        week_explanation = try values.decodeIfPresent(String.self, forKey: .week_explanation)
        week_activity = try values.decodeIfPresent(String.self, forKey: .week_activity)
        content = try values.decodeIfPresent([WeeklyContent].self, forKey: .content)
    }

}

struct WeeklyContent : Codable {
    let photo : String?
    let title : String?
    let video : String?
    let causes : Causes?
    let description : String?
    let thumbnail : String?

    enum CodingKeys: String, CodingKey {

        case photo = "photo"
        case title = "title"
        case video = "video"
        case causes = "Causes"
        case description = "description"
        case thumbnail = "thumbnail"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        photo = try values.decodeIfPresent(String.self, forKey: .photo)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        video = try values.decodeIfPresent(String.self, forKey: .video)
        causes = try values.decodeIfPresent(Causes.self, forKey: .causes)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail)
    }

}

struct Causes : Codable {
    let other_Factors : String?
    let heart_Conditions : String?

    enum CodingKeys: String, CodingKey {

        case other_Factors = "Other_Factors"
        case heart_Conditions = "Heart_Conditions"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        other_Factors = try values.decodeIfPresent(String.self, forKey: .other_Factors)
        heart_Conditions = try values.decodeIfPresent(String.self, forKey: .heart_Conditions)
    }

}
