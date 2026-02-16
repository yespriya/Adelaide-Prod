//
//  LearningProgressView.swift
//  Adelaide Prod
//
//  Created by Prit  on 12/02/26.
//

import SwiftUI

struct LearningProgressView: View {
    
    @StateObject var viewModel = LearningProgessViewModel()
    @State private var selectedModule: ModulePerformance?
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(title: LearningProgressLabels.myLearningProgress)
            
            ScrollView {
                VStack(spacing: 16) {
                    cardsView
                    
                    chartView(modules: viewModel.patientAnalyticsData?.first?.modulePerformance)
                    
                    if let modules = viewModel.patientAnalyticsData?.first?.modulePerformance, !modules.isEmpty {
                        ModulePerformanceDetailsView(modules: modules)
                            .environmentObject(viewModel)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .background(Color(hex: "#F3F4F6"))
        .onAppear {
            viewModel.getLearningProgress()
        }
        .alert(isPresented: $viewModel.isError) {
            Alert(
                title: Text(LearningProgressLabels.error),
                message: Text(viewModel.errorMessage ?? LearningProgressLabels.defaultError),
                dismissButton: .default(Text(LearningProgressLabels.ok))
            )
        }
    }
    
    // MARK: SubViews
    
    var cardsView: some View {
        let cardData = viewModel.patientAnalyticsData?.first
        return VStack(spacing: 16) {
            HStack {
                statsCardView(
                    title: LearningProgressLabels.overAllScore,
                    value: String(cardData?.overallScore ?? 0) + "%",
                    iconName: "percent",
                    iconColor: Color(hex: "#3B82F6")
                )
                
                Spacer()
                
                statsCardView(
                    title: LearningProgressLabels.modulesCompleted,
                    value: "\(cardData?.modulesCompleted ?? 0)/\(cardData?.totalModulesCount ?? 0)",
                    iconName: "checkmark",
                    iconColor: Color(hex: "#10B981")
                )
            }
            
            // Second Row
            HStack {
                statsCardView(
                    title: LearningProgressLabels.completionRate,
                    value: String(format: "%.2f%%", cardData?.completionRate ?? 0),
                    iconName: "chart.xyaxis.line",
                    iconColor: Color(hex: "#F59E0B")
                )
                
                Spacer()
                
                statsCardView(
                    title: LearningProgressLabels.totalModules,
                    value: String(cardData?.totalModulesCount ?? 0),
                    iconName: "doc.text",
                    iconColor: Color(hex: "#EC4899")
                )
            }
        }
        .padding(.top, 8)
    }
    
    
    private func statsCardView(title: String, value: String, iconName: String, iconColor: Color, showInfo: Bool = true) -> some View {
        
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.poppinsSemiBold13)
                    .foregroundStyle(Color(hex: "#9CA3AF"))
                    .lineLimit(2)
                
                Spacer()
                
                if showInfo {
                    Image(systemName: "info.circle")
                        .font(.system(size: 14))
                        .foregroundStyle(Color(hex: "#D1D5DB"))
                }
                
                // Icon Circle
                ZStack {
                    Rectangle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 25, height: 25)
                        .cornerRadius(8)
                    
                    Image(systemName: iconName)
                        .font(.system(size: 10))
                        .foregroundStyle(iconColor)
                }
            }
            
            // Bottom Row: Value
            Text(value)
                .font(.poppinsBold22)
                .foregroundStyle(Color(hex: "#1F2937"))
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
    }
    
    @ViewBuilder
    func chartView(modules: [ModulePerformance]?) -> some View {
        if viewModel.isLoading {
            VStack(spacing: 12) {
                ProgressView()
                    .scaleEffect(1.2)
                Text(LearningProgressLabels.loadingModulePerformance)
                    .font(.poppinsRegular14)
                    .foregroundStyle(Color(hex: "#6B7280"))
            }
            .frame(height: 300)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
            
            
        } else if let modules, !modules.isEmpty {
            ModulePerformanceBarChart(modules: modules)
            
        } else {
            VStack(spacing: 12) {
                Image(systemName: "chart.bar.xaxis")
                    .font(.system(size: 48))
                    .foregroundColor(Color(hex: "#D1D5DB"))
                
                Text(LearningProgressLabels.noModuleData)
                    .font(.poppinsRegular14)
                    .foregroundStyle(Color(hex: "#6B7280"))
            }
            .frame(height: 300)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
        }
    }
}

struct CustomNavigationBar: View {
    var title = ""
    var skipAction: (()->Void)? = nil
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image("ic_back")
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color(hex: "1F1F1F"))
                    }
                    
                    Spacer()
                    
                }
                .padding(.vertical, 8)
                .padding(.leading, 10)
                .padding(.trailing, 16)
                
                Rectangle()
                    .fill(Color(hex: "#D9D9D9"))
                    .frame(height: 0.3)
            }
            Text(title)
                .font(.poppinsSemiBold16)
                .foregroundStyle(Color(hex: "0E0F11"))
        }
        .background(Color(hex: "#F3F4F6"))
        .padding(.bottom, 4)
    }
}
