//
//  QuizView.swift
//  ASLVision
//
//  Created by Théo Arrouye on 2/20/21.
//

import SwiftUI

struct QuizTabView: View {
    @ObservedObject var model = QuizTabViewModel()
    @ObservedObject var quizModel = QuizTakingViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(destination: QuizTakingView(model: quizModel, daddyModel: model), isActive: $model.takingQuiz) {
                    
                }
                
                ScrollView(.vertical) {
                    VStack(spacing: 0) {
                        if (self.model.quizzes.count > 0) {
                            // Results
                            HStack {
                                Text("BEST_RESULTS_LABEL")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    
                                Spacer()
                            }
                            .padding()
                            
                            QuizEntryCardView(entry: model.bestQuiz!)
                                .padding(.horizontal)
                                .padding(.bottom)
                            
                            
                            Divider()
                            
                            HStack {
                                Text("PREV_RESULTS_LABEL")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    
                                Spacer()
                            }
                            .padding()
                            
                            if (self.model.quizzes.count > 1) {
                                ForEach(self.model.quizzes.sorted(by: { $0.date > $1.date } ), id: \.id) { quiz in
                                    if quiz != self.model.bestQuiz {
                                        QuizEntryCardView(entry: quiz)
                                            .padding(.horizontal)
                                            .padding(.bottom)
                                    }
                                }
                            } else {
                                Image("\(model.imageName)")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 250)
                                    .padding()
                                
                                Text("ONLY_ONE_QUIZ_MESSAGE")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding()
                            }
                            
                            Color(UIColor.systemBackground)
                                .frame(height: 50)
                        } else {
                            Text("NO_QUIZZES_TITLE")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding()
                            
                            Image("\(model.imageName)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 250)
                                .padding()
                            
                            Text("NO_QUIZZES_MESSAGE")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding()
                        }
                    }
                }
                .navigationTitle("QUIZZES_LABEL")
                
                
                VStack {
                    Spacer()
                    
                    Button(action: {
                        self.quizModel.reset()
                        self.model.startQuiz()
                    }) {
                        Text("NEW_QUIZ_BTN")
                            .font(.headline)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.blue.clipShape(RoundedRectangle(cornerRadius: 50)))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                }
                
            }
        }
    }
}
