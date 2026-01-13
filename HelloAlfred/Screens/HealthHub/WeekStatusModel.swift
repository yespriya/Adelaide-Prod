
import Foundation
struct WeekStatusModel: Codable {
    let status: Bool?
    let statuscode: Int?
    let message: String?
    let data: [String: Bool]
    
    func isWeekAvailable(_ week: String) -> Bool {
          return data[week] ?? false
      }
}
