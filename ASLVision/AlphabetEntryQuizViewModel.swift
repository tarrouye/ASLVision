//
//  AlphabetEntryQuizViewModel.swift
//  ASLVision
//
//  Created by Théo Arrouye on 2/21/21.
//

import Foundation

enum AlphabetEntryQuizState {
    case ready, withAid, matchedOne, noAid, finished
}

class AlphabetEntryQuizViewModel : ObservableObject {
    @Published var startTime : Date?
    
    @Published var currentTimer : String?
    
    @Published var state : AlphabetEntryQuizState = .ready
    
    var withAidResult : TimeInterval?
    var noAidResult : TimeInterval?
    
    private var timer: Timer?
    
    init() {
        self.startTime = nil
        self.currentTimer = nil
        self.withAidResult = nil
        self.noAidResult = nil
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) {
           _ in self.updateTimer()
        }
    }
    
    func reset() {
        self.startTime = nil
        self.currentTimer = nil
        self.withAidResult = nil
        self.noAidResult = nil
        
        self.state = .ready
    }
    
    @objc func updateTimer() {
        if (self.startTime != nil) {
            self.currentTimer = timeToString(Date().timeIntervalSince(self.startTime!))
        } else {
            self.currentTimer = nil
        }
        
        // remove later, auto match for testing
        if ((state == .withAid || state == .noAid) && Int.random(in: 0...200) == 12 && (self.startTime != nil && (Date().timeIntervalSince(self.startTime!) > 1.5 || Date().timeIntervalSince(self.startTime!) > 5))) {
            matched()
        }
    }
    
    func startTimer() {
        startTime = Date()
    }
    
    func startWithAid() {
        state = .withAid
        
        startTimer()
    }
    
    func startNoAid() {
        state = .noAid
        
        startTimer()
    }
    
    func timeToString(_ tmir: TimeInterval?) -> String {
        if let tmr = tmir {
            return String(format: "%.2f", tmr) + " s"
        }
        
        return "----"
    }
    
    func matched() {
        let time = Date().timeIntervalSince(startTime!)
        
        if (state == .withAid) {
            withAidResult = time
            state = .matchedOne
        } else if (state == .noAid) {
            noAidResult = time
            state = .finished
        }
    }
}
