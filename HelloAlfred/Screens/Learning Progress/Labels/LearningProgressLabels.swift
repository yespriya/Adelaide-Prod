//
//  LearningProgressLabels.swift
//  Adelaide Prod
//
//  Created by Prit  on 14/02/26.
//

import Foundation

class LocalizationManager: NSObject {
    static func localizedString(forKey key: String, comment: String = "") -> String {
        return NSLocalizedString(key, comment: comment)
    }
}


struct LearningProgressLabels {
    // title
    static let myLearningProgress = LocalizationManager.localizedString(forKey: "My Learning Progress")
    // cards
    static let overAllScore = LocalizationManager.localizedString(forKey: "Overall\nScore")
    static let modulesCompleted = LocalizationManager.localizedString(forKey: "Modules\nCompleted")
    static let completionRate = LocalizationManager.localizedString(forKey: "Completion\nRate")
    static let totalModules = LocalizationManager.localizedString(forKey: "Total\nModules")
    static let loadingModulePerformance = LocalizationManager.localizedString(forKey: "Loading module performance...")
    static let noModuleData = LocalizationManager.localizedString(forKey: "No module performance data available")
    static let error = LocalizationManager.localizedString(forKey: "Error")
    static let ok = LocalizationManager.localizedString(forKey: "OK")
    static let defaultError = LocalizationManager.localizedString(forKey: "An error occurred")
    
    // Charts
    static let modulePerformance = LocalizationManager.localizedString(forKey: "Module Performance")
    static let module = LocalizationManager.localizedString(forKey: "Module")
    static let score = LocalizationManager.localizedString(forKey: "Score")
    
    // Details
    static let scoreLabel = LocalizationManager.localizedString(forKey: "Score:")
    static let statusLabel = LocalizationManager.localizedString(forKey: "Status:")
    static let attemptsLabel = LocalizationManager.localizedString(forKey: "Attempts:")
    static let attempts = LocalizationManager.localizedString(forKey: "Attempts")
    static let duration = LocalizationManager.localizedString(forKey: "Duration")
    static let started = LocalizationManager.localizedString(forKey: "Started")
    static let quizSummary = LocalizationManager.localizedString(forKey: "Quiz Summary")
    static let pending = LocalizationManager.localizedString(forKey: "Pending")
    static let na = LocalizationManager.localizedString(forKey: "N/A")
    static let dash = LocalizationManager.localizedString(forKey: "--")
    static let noQuizDataAvailableForThisModule = LocalizationManager.localizedString(forKey: "No quiz data available for this module")
    static let correct = LocalizationManager.localizedString(forKey: "Correct")
    static let correctNotSelected = LocalizationManager.localizedString(forKey: "Correct Answer (Not Selected)")
    static let partiallyCorrect = LocalizationManager.localizedString(forKey: "Partially Correct")
    static let incorrect = LocalizationManager.localizedString(forKey: "Incorrect")
    static let question = LocalizationManager.localizedString(forKey: "Question")
}
