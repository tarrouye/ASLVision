//
//  QuizTakingView.swift
//  ASLVision
//
//  Created by Théo Arrouye on 2/20/21.
//

import SwiftUI

struct QuizTakingView: View {
    @Binding var active : Bool
    @ObservedObject var model : QuizTakingViewModel
    
    var body: some View {
        ZStack {
            if (model.state == .start) {
                NewQuizView(model: model)
            } else if (model.state == .taking) {
                AlphabetEntryQuizView(model: model)
            } else if (model.state == .finished) {
                FinishedQuizView(model: model, active: $active)
            }
        }
    }
}
