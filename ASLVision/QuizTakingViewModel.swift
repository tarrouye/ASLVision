//
//  QuizTakingViewModel.swift
//  ASLVision
//
//  Created by Théo Arrouye on 2/20/21.
//

import Foundation

enum QuizState {
    case start, taking, finished
}

class QuizTakingViewModel : ObservableObject {
    var entry =  QuizEntry(id: UUID(), date: Date(), results: [])
    
    @Published var state : QuizState = .start
    
    @Published var currentAlphabetIndex = 0
    
    private var learningImgNum : Int = Int.random(in: 0...5)
    
    var learningImageName : String {
        return "learning\(learningImgNum)"
    }
    
    func reset() {
        self.state = .start
        self.entry.date = Date()
        self.entry.id = UUID()
        self.entry.results = []
        self.currentAlphabetIndex = 0
        self.learningImgNum = (self.learningImgNum + 1) % 6
    }
    
    func next() {
        if (currentAlphabetIndex + 1 < ALPHABET.count) {
            currentAlphabetIndex += 1
        } else {
            state = .finished
            currentAlphabetIndex = 0
        }
    }
    
    func startQuiz() {
        currentAlphabetIndex = 0
        state = .taking
    }
    
    func logResults(_ entry: AlphabetEntry, _ withAidResult: TimeInterval, _ noAidResult: TimeInterval) {
        let result = QuizResultEntry(alphabet_entry: entry, matchTimeWithAid: withAidResult, matchTimeWithoutAid: noAidResult)
        
        self.entry.results.append(result)
    }
}
