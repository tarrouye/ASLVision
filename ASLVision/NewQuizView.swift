//
//  NewQuizView.swift
//  ASLVision
//
//  Created by Théo Arrouye on 2/20/21.
//

import SwiftUI

struct NewQuizView : View {
    var model : QuizTakingViewModel
    
    var body: some View {
        VStack {
            Text("START_NEW_QUIZ_TITLE")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Image("\(model.learningImageName)")
                .resizable()
                .scaledToFit()
                .frame(width: 300)
                .padding()
            
            Text("START_NEW_QUIZ_MESSAGE")
                .font(.title2)
                .fontWeight(.semibold)
                .padding()
            
            Button(action: {
                model.startQuiz()
            }) {
                Text("LETS_RIDE_BTN")
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
