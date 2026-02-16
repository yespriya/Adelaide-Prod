//
//  BarAnnotationView.swift
//  Adelaide Prod
//
//  Created by Prit  on 12/02/26.
//

import SwiftUI

struct BarAnnotationView: View {
    let module: ModulePerformance
    
    var body: some View {
        VStack(spacing: 0) {
            // Main content card
            VStack(alignment: .leading, spacing: 4) {
                // Module Title
                Text(module.moduleName ?? "Module")
                    .font(.custom("Poppins-SemiBold", size: 13))
                    .foregroundColor(Color(hex: "#1F2937"))
                    .lineLimit(2)
                
                // Score
                HStack(spacing: 4) {
                    Text("Score:")
                        .font(.custom("Poppins-Regular", size: 11))
                        .foregroundColor(Color(hex: "#6B7280"))
                    
                    Text("\(String(format: "%.2f", module.moduleScore ?? 0))%")
                        .font(.custom("Poppins-Bold", size: 11))
                        .foregroundColor(scoreColor(for: module.moduleScore ?? 0))
                }
                
                // Status
                HStack(spacing: 4) {
                    Text("Status:")
                        .font(.custom("Poppins-Regular", size: 11))
                        .foregroundColor(Color(hex: "#6B7280"))
                    
                    Text(module.status ?? "N/A")
                        .font(.custom("Poppins-Medium", size: 11))
                        .foregroundColor(Color(hex: "#1F2937"))
                }
                
                // Attempts
                if let attempts = module.noOfAttempts, attempts > 0 {
                    HStack(spacing: 4) {
                        Text("Attempts:")
                            .font(.custom("Poppins-Regular", size: 11))
                            .foregroundColor(Color(hex: "#6B7280"))
                        
                        Text("\(attempts)")
                            .font(.custom("Poppins-Medium", size: 11))
                            .foregroundColor(Color(hex: "#1F2937"))
                    }
                }
            }
            .padding(10)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
            
            // Speech bubble pointer (triangle)
            Triangle()
                .fill(Color.white)
                .frame(width: 14, height: 8)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                .offset(y: -1)
        }
    }
    
    private func scoreColor(for score: Double) -> Color {
        if score >= 75 {
            return Color(hex: "#10B981") // Green
        } else if score >= 50 {
            return Color(hex: "#F59E0B") // Orange
        } else {
            return Color(hex: "#EF4444") // Red
        }
    }
}

// Triangle shape for speech bubble pointer
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}
