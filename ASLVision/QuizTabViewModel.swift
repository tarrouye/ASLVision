//
//  QuizTabViewModel.swift
//  ASLVision
//
//  Created by Théo Arrouye on 2/21/21.
//

import Foundation

class QuizTabViewModel: ObservableObject {
    var quizzes : [QuizEntry] = []
    
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
    
    @Published var takingQuiz : Bool = false
    
    private var imgNum : Int = Int.random(in: 0...8)
    
    @Published var imageName : String = "empty0"
    
    private var timer: Timer?
    
    init() {
        imageName = "empty\(imgNum)"
        self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) {
           _ in self.updateImage()
        }
        
        self.getResultsFromFile()
    }
    
    @objc func updateImage() {
        imgNum = (imgNum + Int.random(in: 1...8)) % 9
        imageName = "empty\(imgNum)"
    }
    
    func logResult(_ entry : QuizEntry) {
        self.quizzes.append(entry)
        
        writeResultsToFile()
    }
    
    func writeResultsToFile() {
        do {
            let jsonData = try JSONEncoder().encode(self.quizzes)
            
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let pathWithFileName = documentDirectory.appendingPathComponent("ALL_QUIZ_RESULTS")
                do {
                    try jsonData.write(to: pathWithFileName)
                } catch {
                    //  error
                }
            }
        } catch {
            // error
        }
    }
    
    func getResultsFromFile() {
        
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let pathWithFileName = documentDirectory.appendingPathComponent("ALL_QUIZ_RESULTS")
            do {
                let data = try Data(contentsOf: pathWithFileName, options: .mappedIfSafe)
                let results = try JSONDecoder().decode([QuizEntry].self, from: data)
                self.quizzes = results
            } catch {
                //  error
            }
        }
    }
    
    func startQuiz() {
        self.takingQuiz = true
        
        self.timer?.invalidate()
        self.timer = nil
    }

}
