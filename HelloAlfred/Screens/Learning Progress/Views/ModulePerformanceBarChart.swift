//
//  ModulePerformanceBarChart.swift
//  Adelaide Prod
//
//  Created by Prit  on 12/02/26.
//

import SwiftUI
import Charts

struct ModulePerformanceBarChart: View {
    
    let modules: [ModulePerformance]
    let barWidth: CGFloat = 40
    
    @State private var selectedName: String?
    @State private var selectedModule: ModulePerformance?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack(spacing: 4) {
                Text(LearningProgressLabels.modulePerformance)
                    .font(.poppinsSemiBold18)
                    .foregroundStyle(Color(hex: "#1F2937"))
                
                
                Image(systemName: "info.circle")
                    .font(.poppinsRegular16)
                    .foregroundStyle(Color(hex: "#9CA3AF"))
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                Chart(modules, id: \.moduleName) { module in
                    BarMark(
                        x: .value(LearningProgressLabels.module, module.moduleName ?? ""),
                        y: .value(LearningProgressLabels.score, module.moduleScore ?? 0)
                    )
                    .foregroundStyle(color(for: module.moduleScore ?? 0))
                    .cornerRadius(6)

                }
                .onChange(of: selectedName) { newValue in
                    selectedModule = modules.first {
                        $0.moduleName == newValue
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisValueLabel {
                            if let name = value.as(String.self) {
                                Text(name.replacingOccurrences(of: " ", with: ""))
                                    .font(.poppinsSemiBold9)
                                    .rotationEffect(.degrees(-45))
                                    .fixedSize()
                                    .padding(.vertical, 12)
                                
                            }
                        }
                    }
                }
                .padding(.top, 8)
                .frame(width: barWidth * CGFloat(modules.count), height: 300)
            }
        }
        .padding(16)
        .background(.white)
        .cornerRadius(16)
        .shadow(radius: 4)
    }
    
    private func color(for score: Double) -> Color {
        switch score {
        case 75...: return .green
        case 50..<75: return .orange
        case 1..<50: return .red
        default: return .clear
        }
    }
}
