//
//  AlphabetEntryCardView.swift
//  ASLVision
//
//  Created by Théo Arrouye on 2/20/21.
//

import SwiftUI

struct AlphabetEntryCardView : View {
    @ObservedObject var entry : AlphabetEntry
    
    var matchTimeTitle : LocalizedStringKey = "AVG_MATCH_TIMES"
    
    var body: some View {
        ZStack {
            // Image
            ZStack {
                Circle()
                    .foregroundColor(Color.blue)
                
                Image("\(entry.char.uppercased())_test")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
            }
            .frame(width: 150, height: 150)
            .padding()
            
            VStack(alignment: .leading) {
                HStack {
                    HStack(spacing: 0) {
                        Text("CHAR_LABEL")
                            .font(.headline)
                            .fontWeight(.regular)
                        
                        Text("\(entry.char.uppercased())")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    .padding()
                    
                    
                    
                    Spacer()
                }
                
                AverageMatchTimesView(aid: entry.avgWithAid, withoutAid: entry.avgWithoutAid, title: matchTimeTitle)
                .padding(.vertical)
            }
            .background(BackgroundBlurView().opacity(0.8).clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous)))
        
                
        }
        .background(BackgroundBlurView().background(Color(UIColor.tertiarySystemGroupedBackground))).clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
    }
}
