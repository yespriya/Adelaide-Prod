
//
//  QuizSummaryView.swift
//  Adelaide Prod
//
//  Created by Prit  on 14/02/26.
//

import SwiftUI

struct QuizSummaryView: View {
    let quizData: QuizAnalyticsData
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            header
            
            if let questions = quizData.quiz_data, !questions.isEmpty {
                // Legend
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        LegendItem(text: LearningProgressLabels.correct, color: Color(hex: "#10B981"), icon: "checkmark.circle")
                        LegendItem(text: LearningProgressLabels.correctNotSelected, color: Color(hex: "#3B82F6"), icon: "checkmark")
                        LegendItem(text: LearningProgressLabels.partiallyCorrect, color: Color(hex: "#F59E0B"), icon: "exclamationmark.circle")
                        LegendItem(text: LearningProgressLabels.incorrect, color: Color(hex: "#EF4444"), icon: "xmark.circle")
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                
                // List of Questions
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(Array(questions.enumerated()), id: \.offset) { index, question in
                            QuestionCard(index: index + 1, question: question)
                        }
                    }
                    .padding()
                }
                .frame(maxHeight: .infinity)
                .background(Color(hex: "#F9FAFB"))
            } else {
                // Empty State
                VStack(spacing: 16) {
                    Image(systemName: "tray")
                        .font(.system(size: 48))
                        .foregroundStyle(Color(hex: "#6B7280"))
                    
                    Text(LearningProgressLabels.noQuizDataAvailableForThisModule)
                        .font(.poppinsRegular16)
                        .foregroundStyle(Color(hex: "#6B7280"))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(hex: "#F9FAFB"))
            }
        }
        .background(Color.white)
        .cornerRadius(20) // For bottom sheet look if needed
    }
    // MARK: Views
    
    var header: some View {
        HStack {
            Image(systemName: "lock")
                .font(.poppinsMedium16)
                .foregroundStyle(Color(hex: "#1F2937"))
            
            Text("\(LearningProgressLabels.quizSummary) – \(quizData.module_name ?? "Module")")
                .font(.poppinsSemiBold18)
                .foregroundStyle(Color(hex: "#1F2937"))
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14))
                    .foregroundStyle(Color(hex: "#6B7280"))
                    .padding(8)
                    .background(Color(hex: "#F3F4F6"))
                    .clipShape(Circle())
            }
        }
        .padding(8)
    }
}

struct LegendItem: View {
    let text: String
    let color: Color
    let icon: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10))
            Text(text)
                .font(.poppinsMedium10)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .foregroundStyle(color)
        .background(color.opacity(0.1))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

struct QuestionCard: View {
    let index: Int
    let question: QuizQuestionData
    
    var status: QuestionStatus? {
        let correctAnswers = Set(question.correct_answer ?? [])
        let selectedAnswers = Set(question.selected_answer ?? [])
        
        if correctAnswers.isEmpty {
            return nil
        }
        
        if selectedAnswers.isEmpty {
            return .unanswered
        }
        
        let correctSelected = selectedAnswers.intersection(correctAnswers)
        let incorrectSelected = selectedAnswers.subtracting(correctAnswers)
        
        if incorrectSelected.isEmpty && correctSelected.count == correctAnswers.count {
            return .correct
        } else if !incorrectSelected.isEmpty && correctSelected.isEmpty {
            return .incorrect
        } else {
            return .partiallyCorrect // Or if incorrectSelected is not empty
        }
    }
    
    enum QuestionStatus {
        case correct, incorrect, partiallyCorrect, unanswered
        
        var color: Color {
            switch self {
            case .correct: return Color(hex: "#10B981")
            case .incorrect: return Color(hex: "#EF4444")
            case .partiallyCorrect: return Color(hex: "#F59E0B")
            case .unanswered: return Color.gray
            }
        }
        
        var title: String {
            switch self {
            case .correct: return "Correct"
            case .incorrect: return "Incorrect"
            case .partiallyCorrect: return "Partially Correct"
            case .unanswered: return "Unanswered"
            }
        }
        
        var icon: String {
            switch self {
            case .correct: return "checkmark.circle.fill"
            case .incorrect: return "xmark.circle.fill"
            case .partiallyCorrect: return "exclamationmark.circle.fill"
            case .unanswered: return "circle"
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text("\(LearningProgressLabels.question) \(index)")
                    .font(.poppinsMedium12)
                    .foregroundStyle(Color(hex: "#6B7280"))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(hex: "#F3F4F6"))
                    .cornerRadius(8)
                
                Spacer()
                
                if let status = status {
                    HStack(spacing: 4) {
                        Image(systemName: status.icon)
                            .font(.system(size: 12))
                        Text(status.title)
                             .font(.poppinsSemiBold12)
                    }
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(status.color)
                    .cornerRadius(12)
                }
            }
            
            // Question Text
            Text(question.question ?? "")
                .font(.poppinsSemiBold14) // Or 16
                .foregroundStyle(Color(hex: "#1F2937"))
                .fixedSize(horizontal: false, vertical: true)
            
            // Options
            VStack(spacing: 8) {
                if let options = question.options, !options.isEmpty {
                    ForEach(options, id: \.self) { option in
                        OptionRow(option: option,
                                  isSelected: (question.selected_answer ?? []).contains(option),
                                  isCorrect: (question.correct_answer ?? []).contains(option),
                                  hasCorrectAnswer: !(question.correct_answer ?? []).isEmpty)
                    }
                } else if let selectedAnswers = question.selected_answer, !selectedAnswers.isEmpty {
                     ForEach(selectedAnswers, id: \.self) { answer in
                         OptionRow(option: answer, isSelected: false, isCorrect: true, hasCorrectAnswer: true)
                     }
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
    }
}

struct OptionRow: View {
    let option: String
    let isSelected: Bool
    let isCorrect: Bool
    let hasCorrectAnswer: Bool
    
    var body: some View {
        HStack {
            if isSelected {
                Image(systemName: isCorrect ? "checkmark.circle" : "xmark.circle")
                    .font(.system(size: 16))
                    .foregroundStyle(getStateColor())
            } else if isCorrect {
                Image(systemName: "checkmark")
                     .font(.system(size: 12))
                     .foregroundStyle(Color(hex: "#3B82F6"))
            }

            Text(option)
                .font(.poppinsRegular14)
                .foregroundStyle(Color(hex: "#374151"))
            
            Spacer()
        }
        .padding()
        .background(getBackgroundColor())
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(getBorderColor(), lineWidth: 1)
        )
    }
    
    func getStateColor() -> Color {
        if isSelected {
            if !hasCorrectAnswer {
                 return Color(hex: "#3B82F6")
            }
            return isCorrect ? Color(hex: "#10B981") : Color(hex: "#EF4444")
        } else if isCorrect {
            return Color(hex: "#3B82F6")
        }
        return Color(hex: "#E5E7EB")
    }
    
    func getBackgroundColor() -> Color {
        if isSelected {
            if !hasCorrectAnswer {
                 return Color(hex: "#EFF6FF")
            }
            return isCorrect ? Color(hex: "#ECFDF5") : Color(hex: "#FEF2F2") // Green-50 / Red-50
        } else if isCorrect {
            return Color(hex: "#EFF6FF")
        }
        return Color(hex: "#F9FAFB")
    }
    
    func getBorderColor() -> Color {
        if isSelected {
            if !hasCorrectAnswer {
                 return Color(hex: "#3B82F6")
            }
            return isCorrect ? Color(hex: "#10B981") : Color(hex: "#EF4444")
        } else if isCorrect {
            return Color(hex: "#3B82F6")
        }
        return Color.clear
    }
}
