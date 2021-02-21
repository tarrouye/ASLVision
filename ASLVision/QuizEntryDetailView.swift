//
//  QuizDetailView.swift
//  ASLVision
//
//  Created by Théo Arrouye on 2/21/21.
//

import SwiftUI

struct QuizEntryDetailView: View {
    var entry: QuizEntry
    
    static let dateAndTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy @ h:mm a"
        return formatter
    }()
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                HStack {
                    Text("\(entry.date, formatter: Self.dateAndTimeFormatter)")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                .padding()
                
                QuizResultsListView(entry: self.entry)
                    .navigationTitle("Quiz Results")
            }
        }
    }
}

