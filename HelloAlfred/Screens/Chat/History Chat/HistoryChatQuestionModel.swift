import Foundation

struct HistoryChatQuestionModel: Codable {
    let statuscode: Int?
    let status: Bool?
    let message: String?
    let data: InitialQuestionData?

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
        data = try values.decodeIfPresent(InitialQuestionData.self, forKey: .data)
    }
}

struct InitialQuestionData: Codable {
    let question_key: String?
    let ans_category: String?
    let description: String?
    let main_type: String?
    let type_: String?
    let yes: String?
    let no: String?
    let options: [String]?

    enum CodingKeys: String, CodingKey {
        case question_key = "question_key"
        case ans_category = "ans_category"
        case description = "description"
        case main_type = "main_type"
        case type_ = "type_"
        case yes = "yes"
        case no = "no"
        case options = "options"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        question_key = try values.decodeIfPresent(String.self, forKey: .question_key)
        ans_category = try values.decodeIfPresent(String.self, forKey: .ans_category)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        main_type = try values.decodeIfPresent(String.self, forKey: .main_type)
        type_ = try values.decodeIfPresent(String.self, forKey: .type_)
        yes = try values.decodeIfPresent(String.self, forKey: .yes)
        no = try values.decodeIfPresent(String.self, forKey: .no)

        // Custom decoding for 'options'
        if let optionsArray = try? values.decodeIfPresent([String].self, forKey: .options) {
            options = optionsArray
        } else if let optionsString = try? values.decodeIfPresent(String.self, forKey: .options) {
            options = [optionsString]
        } else {
            options = nil
        }
    }
}

