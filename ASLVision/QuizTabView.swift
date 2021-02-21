//
//  QuizView.swift
//  ASLVision
//
//  Created by Théo Arrouye on 2/20/21.
//

import SwiftUI

struct QuizTabView: View {
    @ObservedObject var model = QuizTakingViewModel()
    
    var quizzes: [QuizEntry] = [
        QuizEntry(id: UUID(), date: Date(), results: [
            QuizResultEntry(alphabet_entry: AlphabetEntry(char: "a"), matchTimeWithAid: 13, matchTimeWithoutAid: 38),
            QuizResultEntry(alphabet_entry: AlphabetEntry(char: "b"), matchTimeWithAid: 10, matchTimeWithoutAid: 30)
        ]),
        
        QuizEntry(id: UUID(), date: Date().addingTimeInterval(-1762.0), results: [
            QuizResultEntry(alphabet_entry: AlphabetEntry(char: "a"), matchTimeWithAid: 23, matchTimeWithoutAid: 45),
            QuizResultEntry(alphabet_entry: AlphabetEntry(char: "b"), matchTimeWithAid: 17, matchTimeWithoutAid: 87)
        ]),
        
        QuizEntry(id: UUID(), date: Date().addingTimeInterval(-289.0), results: [
            QuizResultEntry(alphabet_entry: AlphabetEntry(char: "a"), matchTimeWithAid: 23, matchTimeWithoutAid: 45),
            QuizResultEntry(alphabet_entry: AlphabetEntry(char: "b"), matchTimeWithAid: 17, matchTimeWithoutAid: 87),
            QuizResultEntry(alphabet_entry: AlphabetEntry(char: "c"), matchTimeWithAid: 5, matchTimeWithoutAid: 3)
        ])
    ]
    
    var bestQuiz : QuizEntry? {
        var bestnoaid : TimeInterval? = nil
        var bestquiz: QuizEntry? = nil
        
        for q in quizzes {
            if bestnoaid == nil || q.avgWithoutAid < bestnoaid! {
                bestnoaid = q.avgWithoutAid
                bestquiz = q
            }
        }
        
        return bestquiz
    }
    
    @State var isTakingQuiz : Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(destination: QuizTakingView(active: $isTakingQuiz, model: model), isActive: $isTakingQuiz) {
                    
                }
                
                ScrollView(.vertical) {
                    VStack(spacing: 0) {
                        if (self.quizzes.count > 0) {
                            // Results
                            HStack {
                                Text("BEST_RESULTS_LABEL")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    
                                Spacer()
                            }
                            .padding()
                            
                            QuizEntryCardView(entry: bestQuiz!)
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
                            
                            ForEach(self.quizzes.sorted(by: { $0.date > $1.date } ), id: \.id) { quiz in
                                if quiz != self.bestQuiz {
                                    QuizEntryCardView(entry: quiz)
                                        .padding(.horizontal)
                                        .padding(.bottom)
                                }
                            }
                            
                            Color(UIColor.systemBackground)
                                .frame(height: 50)
                        } else {
                            Text("NO QUIZZES")
                        }
                    }
                }
                .navigationTitle("QUIZZES_LABEL")
                
                
                VStack {
                    Spacer()
                    
                    Button(action: {
                        self.model.reset()
                        self.isTakingQuiz = true
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
