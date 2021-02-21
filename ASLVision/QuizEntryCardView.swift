//
//  QuizEntryCardView.swift
//  ASLVision
//
//  Created by Théo Arrouye on 2/20/21.
//

import SwiftUI

struct QuizEntryCardView : View {
    var entry : QuizEntry
    
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
    static let dateAndTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy @ h:mm a"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .center) {
            AverageMatchTimesView(aid: entry.avgWithAid, withoutAid: entry.avgWithoutAid)
                .padding(.vertical)
            
            Spacer()
            
            HStack {
                Spacer()
            
                Text("\(entry.date, formatter: Self.dateAndTimeFormatter)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.trailing, 5)
                    .padding(.bottom, 5)
            }
            
        }
        .background(Color(UIColor.tertiarySystemGroupedBackground).clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous)))
    }
}
