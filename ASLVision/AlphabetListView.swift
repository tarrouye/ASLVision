//
//  AlphabetListView.swift
//  ASLVision
//
//  Created by Théo Arrouye on 2/20/21.
//

import SwiftUI

struct AlphabetListView: View {
    var model = QuizTakingViewModel()
    
    @State var isShowingQuiz : Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                NavigationLink(destination: AlphabetEntryQuizView(model: model), isActive: $isShowingQuiz) {
                    EmptyView()
                }
                
                ForEach(ALPHABET, id: \.char) { entry in
                    
                    
                    Button(action: {
                        if let ind = ALPHABET.firstIndex(where: { $0 == entry }) {
                            model.currentAlphabetIndex = ind
                            self.isShowingQuiz = true
                        }
                    }) {
                        AlphabetEntryCardView(entry: entry, avgWithAid: 15.0, avgWithoutAid: 33.0)
                            .padding()
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("ALPHABET_LABEL")
        }
    }
}
