//
//  FinishedQuizView.swift
//  ASLVision
//
//  Created by Théo Arrouye on 2/20/21.
//

import SwiftUI

struct FinishedQuizView: View {
    var model: QuizTakingViewModel
    var daddyModel: QuizTabViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                Text("FINISHED_QUIZ_TITLE")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                Image("\(model.learningImageName)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .padding()
                
                Text("RESULTS_LABEL")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                
                AverageMatchTimesView(aid: model.entry.avgWithAid, withoutAid: model.entry.avgWithoutAid)
                    .padding(.vertical)
                    .background(BackgroundBlurView().clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous)))
                    .padding(.horizontal)
                    .padding(.bottom)
                
                Divider()
                    .padding(.bottom)
                
                ForEach(model.entry.results, id: \.self) { res in
                    AlphabetEntryCardView(entry: res.alphabet_entry, matchTimeTitle: "MATCH_TIMES")
                        .padding(.horizontal)
                        .padding(.bottom)
                }
                
                Button(action: {
                    daddyModel.logResult(model.entry)
                    daddyModel.takingQuiz.toggle()
                }) {
                    Text("CLOSE_BTN")
                        .font(.headline)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.blue.clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous)))
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
                .navigationTitle("QUIZ_LABEL")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
