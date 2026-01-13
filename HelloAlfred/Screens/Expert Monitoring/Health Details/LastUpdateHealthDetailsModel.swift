
import Foundation
struct LastUpdateHealthDetailsModel: Codable {
    let statuscode: Int?
    let status: Bool?
    let message: String?
    let data: HealthUpdateData?

    enum CodingKeys: String, CodingKey {
        case statuscode
        case status
        case message
        case data
    }
}

struct HealthUpdateData: Codable {
    let date: String?
    let difference: String?

    enum CodingKeys: String, CodingKey {
        case date
        case difference
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        
        // Try to decode difference as an Int first
        if let intValue = try? values.decode(Int.self, forKey: .difference) {
            difference = String(intValue)
        } else {
            // Fallback to decoding it as a String
            difference = try values.decodeIfPresent(String.self, forKey: .difference)
        }
    }
}

