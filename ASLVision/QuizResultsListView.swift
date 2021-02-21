//
//  QuizResultsListView.swift
//  ASLVision
//
//  Created by Théo Arrouye on 2/21/21.
//

import SwiftUI

struct QuizResultsListView : View {
    var entry: QuizEntry
    
    var body: some View {
        VStack {
            AverageMatchTimesView(aid: entry.avgWithAid, withoutAid: entry.avgWithoutAid)
                .padding(.vertical)
                .background(BackgroundBlurView().clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous)))
                .padding(.horizontal)
                .padding(.bottom)
            
            Divider()
                .padding(.bottom)
            
            ForEach(entry.results, id: \.self) { res in
                AlphabetEntryCardView(entry: res.alphabet_entry, aidTime: res.matchTimeWithAid, noAidTime: res.matchTimeWithoutAid, matchTimeTitle: "MATCH_TIMES")
                    .padding(.horizontal)
                    .padding(.bottom)
            }
        }
    }
}
