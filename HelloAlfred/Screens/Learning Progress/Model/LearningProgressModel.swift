//
//  LearningProgressModels.swift
//  Adelaide Prod
//
//  Created by Prit  on 12/02/26.
//

import Foundation

// MARK: - Request Model
struct LearningAnalyticsRequestModel: Codable {
    let patient_id: String?
    let subdomain: String?
}

// MARK: - Data Model
struct PatientAnalyticsData: Codable {
    let lastLogin: String?
    let patientId: String?
    let overallScore: Double?
    let modulesCompleted: Double?
    let totalModulesCount: Double?
    let completionRate: Double?
    let modulePerformance: [ModulePerformance]?

    enum CodingKeys: String, CodingKey {
        case lastLogin = "last_login"
        case patientId = "patient_id"
        case overallScore = "overall_score"
        case modulesCompleted = "modules_completed"
        case totalModulesCount = "total_modules_count"
        case completionRate = "completion_rate"
        case modulePerformance = "module_performance"
    }
}

struct ModulePerformance: Codable {
    let moduleName: String?
    let moduleTitle: String?
    let weekKey: String?
    let moduleScore: Double?
    let moduleStartedDate: String?
    let moduleCompletionDate: String?
    let totalDuration: String?
    let status: String?
    let noOfAttempts: Double?

    enum CodingKeys: String, CodingKey {
        case moduleName = "module_name"
        case moduleTitle = "Module_title"
        case weekKey = "week_key"
        case moduleScore = "module_score"
        case moduleStartedDate = "module_started_date"
        case moduleCompletionDate = "module_completion_date"
        case totalDuration = "total_duration"
        case status
        case noOfAttempts = "no_of_attempts"
    }
}

struct WeekWiseQuizAnalyticsRequestModel: Codable {
    let patient_id: String
    let week_key: String
}

struct QuizAnalyticsData: Codable {
    let module_name: String?
    let week_key: String?
    let patient_id: String?
    let quiz_data: [QuizQuestionData]?
}

struct QuizQuestionData: Codable {
    let question: String?
    let correct_answer: [String]?
    let selected_answer: [String]?
    let options: [String]?
    let choice: String?
}
