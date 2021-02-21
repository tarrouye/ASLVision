//
//  AverageMatchTimesView.swift
//  ASLVision
//
//  Created by Théo Arrouye on 2/20/21.
//

import SwiftUI

struct AverageMatchTimesView : View {
    var aid: TimeInterval
    var withoutAid: TimeInterval
    var title: LocalizedStringKey = "AVG_MATCH_TIMES"
    
    func timeToString(_ inter : TimeInterval) -> String {
        return "\(String(format: "%.2f", inter)) s"
    }
    
    var grade: String {
        var avg = (aid + withoutAid) / 2
        
        let list = ["A+", "A", "B+", "B", "C+", "C", "D+", "D", "F"]
        var selected = 0
        while avg > 10 {
            selected += 1
            avg -= 5
        }
        
        return list[selected]
    }
    
    var gradeColor : Color {
        var avg = (aid + withoutAid) / 2
        
        if avg < 15 {
            return .green
        } else if avg < 30 {
            return .yellow
        } else if avg < 45 {
            return .orange
        }
        
        return .red
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .padding(.bottom)
            
            HStack {
                Spacer()
                
                // Grade
                ZStack {
                    Circle()
                        .foregroundColor(gradeColor)
                    
                    Text(grade)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .frame(width: 50, height: 50)
                
                Spacer()
                
                VStack {
                    Text("\(timeToString(aid))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.red)
                    
                    Text("With Aid")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                
                Spacer()
            
                VStack {
                    Text("\(timeToString(withoutAid))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.green)
                    
                    Text("Without Aid")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                
                Spacer()
            }
        }
    }
}
