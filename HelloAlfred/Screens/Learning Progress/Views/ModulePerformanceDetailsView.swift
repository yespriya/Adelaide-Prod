//
//  LearningProgressLabels.swift
//  Adelaide Prod
//
//  Created by Prit  on 14/02/26.
//

import SwiftUI

struct ModulePerformanceDetailsView: View {
    @EnvironmentObject var viewModel: LearningProgessViewModel
    let modules: [ModulePerformance]
    @State private var selectedQuizData: QuizAnalyticsData?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 4) {
                Text("Module Performance")
                    .font(.poppinsSemiBold18)
                    .foregroundStyle(Color(hex: "#1F2937"))
                
                
                Image(systemName: "info.circle")
                    .font(.poppinsRegular16)
                    .foregroundStyle(Color(hex: "#9CA3AF"))
            }
            .padding(.horizontal, 4)
            
            VStack(spacing: 16) {
                ForEach(modules, id: \.moduleName) { module in
                    moduleDetailCard(module: module)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .fullScreenCover(item: $selectedQuizData) { data in
            QuizSummaryView(quizData: data)
        }
    }
    
    
    // MARK: Views
    
    private func moduleDetailCard(module: ModulePerformance) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(module.moduleName ?? "Module")
                    .font(.poppinsSemiBold14)
                    .foregroundStyle(Color(hex: "#1F2937"))
                
                Spacer()
                
                statusBadge(status: module.status ?? "Pending")
            }
            
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    goalStatRow(label: "Score", value: String(format: "%.2f%%", module.moduleScore ?? 0))
                    goalStatRow(label: "Duration", value: module.totalDuration ?? "--")
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 8) {
                    goalStatRow(label: "Attempts", value: "\(module.noOfAttempts ?? 0)")
                    goalStatRow(label: "Started", value: module.moduleStartedDate?.toFormattedDate() ?? "--")
                }
            }
            
            Button {
                if let weekKey = module.weekKey {
                    viewModel.getWeekWiseQuizAnalytics(weekKey: weekKey) { success in
                        if success {
                            if let data = viewModel.weekWiseQuizAnalyticsData?.first(where: { $0.week_key == weekKey }) ?? viewModel.weekWiseQuizAnalyticsData?.first {
                                self.selectedQuizData = data
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "lock")
                        .font(.system(size: 12))
                    
                    Text("Quiz Summary")
                        .font(.poppinsSemiBold12)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(hex: "#3B82F6"), lineWidth: 1)
                )
                .foregroundStyle(Color(hex: "#3B82F6"))
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(Color(hex: "#f9fafc"))
        .cornerRadius(12)
    }
    
    private func statusBadge(status: String) -> some View {
        var isCompleted: Bool {
            status.lowercased().contains("completed")
        }
        return Text(status)
            .font(.poppinsMedium10)
            .foregroundStyle(Color.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(isCompleted ? Color(hex: "#10B981") : Color(hex: "#F97316"))
            .cornerRadius(12)
    }
    
    private func goalStatRow(label: String, value: String) -> some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.poppinsRegular12)
                .foregroundStyle(Color(hex: "#6B7280"))
                .frame(width: 60, alignment: .leading)
            
            Text(value)
                .font(.poppinsMedium12)
                .foregroundStyle(Color(hex: "#1F2937"))
        }
    }
}

extension QuizAnalyticsData: Identifiable {
    var id: String {
        return (week_key ?? "") + (module_name ?? "") + UUID().uuidString
    }
}
