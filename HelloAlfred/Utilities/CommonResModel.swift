
import Foundation
struct CommonResModel : Codable {
	let message : String?
	let statuscode : Int?
	let status : Bool?
    let data : DataToken?

	enum CodingKeys: String, CodingKey {

		case message = "message"
		case statuscode = "statuscode"
		case status = "status"
        case data = "data"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		statuscode = try values.decodeIfPresent(Int.self, forKey: .statuscode)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
		data = try values.decodeIfPresent(DataToken.self, forKey: .data)
	}

}
struct DataToken : Codable {
    let token : String?

    enum CodingKeys: String, CodingKey {

        case token = "token"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }

}
//
//
//import Foundation
//struct HealthHubStatusResponse : Codable {
//    let message : String?
//    let statuscode : Int?
//    let status : Bool?
//    let data : Bool?
//
//    enum CodingKeys: String, CodingKey {
//
//        case message = "message"
//        case statuscode = "statuscode"
//        case status = "status"
//        case data = "data"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        message = try values.decodeIfPresent(String.self, forKey: .message)
//        statuscode = try values.decodeIfPresent(Int.self, forKey: .statuscode)
//        status = try values.decodeIfPresent(Bool.self, forKey: .status)
//        data = try values.decodeIfPresent(Bool.self, forKey: .data)
//    }
//
//}
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - WelcomeElement
struct HealthHubStatusResponse: Codable {
    let status: Bool?
    let statuscode: Int?
    let message: String?
    let data: DataUnion
}

enum DataUnion: Codable {
    case bool(Bool)
    case dataClass(DataClass)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if let x = try? container.decode(DataClass.self) {
            self = .dataClass(x)
            return
        }
        throw DecodingError.typeMismatch(DataUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for DataUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let x):
            try container.encode(x)
        case .dataClass(let x):
            try container.encode(x)
        }
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let quizStatus: Bool

    enum CodingKeys: String, CodingKey {
        case quizStatus = "quiz_status"
    }
}
