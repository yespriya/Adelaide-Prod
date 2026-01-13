//
//  QuizModel.swift
//  HelloAlfred
//
//  Created by SS on 07/08/25.
//

import Foundation

struct QuestionResponse: Codable {
    let statuscode: Int?
    let status: Bool?
    let message: String?
    let data: QuestionData?
}

struct QuestionData: Codable {
    let questions: [Question]?
    let questionCount: Int?

    enum CodingKeys: String, CodingKey {
        case questions
        case questionCount = "question_count"
    }
}

struct Question: Codable {
    let questionNo: Int?
    let question: String?
    let options: [String]?
    let choice: String?
    let minScale: Int?
    let maxScale: Int?
    let label: [String: String]?
    let comment: String?
    let issubmitbtn : Bool?
    let isparent : Bool?
    
    enum CodingKeys: String, CodingKey {
        case questionNo = "question_no"
        case question
        case options
        case choice
        case minScale = "min_scale"
        case maxScale = "max_scale"
        case label
        case comment
        case issubmitbtn
        case isparent
    }
}

struct QuestionEvaluatedResponse: Codable {
    let statuscode: Int?
    let status: Bool?
    let message: String?
    let data: QuestionEvaluatedResponseData?
}

struct QuestionEvaluatedResponseData: Codable {
    let answer_status: Bool?
    let explanation: String?
    let feedback_status: Bool?
    let survey_status: Bool?
    let input_status: Bool?
}
