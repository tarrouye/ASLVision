//
//  AlphabetEntryQuizView.swift
//  ASLVision
//
//  Created by Théo Arrouye on 2/20/21.
//

import SwiftUI

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

struct AlphabetEntryQuizView: View {
    @ObservedObject var model: QuizTakingViewModel
    
    @ObservedObject var privModel = AlphabetEntryQuizViewModel()
    
    var entry : AlphabetEntry {
        return ALPHABET[model.currentAlphabetIndex]
    }
    
    var body: some View {
        ZStack {
            VStack {
                PreviewHolder()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .onTapGesture {
                if (privModel.state == .ready) {
                    privModel.startWithAid()
                } else if (privModel.state == .matchedOne) {
                    privModel.startNoAid()
                }
            }
            
            VStack {
                HStack(spacing: 0) {
                    Text("Character: ")
                        .font(.title)
                        .fontWeight(.regular)
                    
                    Text("\(entry.char.uppercased())")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(5)
                .padding(.horizontal, 5)
                .background(Color(UIColor.tertiarySystemGroupedBackground).cornerRadius(50))
                .padding()
                
                if (privModel.state == .withAid || privModel.state == .noAid) {
                    Text("Time: \(privModel.currentTimer ?? "----")")
                        .padding(5)
                        .padding(.horizontal, 5)
                        .background(Color(UIColor.tertiarySystemGroupedBackground).cornerRadius(50))
                }
            
                Spacer()
                
                if (privModel.state == .ready) {
                    Text("When you're ready, tap the camera preview to start the timer and show the guide.")
                        .font(.headline)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .padding(10)
                        .padding(.horizontal, 10)
                        .background(Color(UIColor.tertiarySystemGroupedBackground).cornerRadius(25))
                        .frame(width: 300)
                } else if (privModel.state == .withAid) {
                    Text("Match the following:")
                        .font(.title2)
                        .padding(5)
                        .padding(.horizontal, 5)
                        .background(Color(UIColor.tertiarySystemGroupedBackground).cornerRadius(50))
                    
                    Image("\(entry.char.uppercased())_test")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(x: -1, y: 1)
                        .frame(width: 300)
                        .opacity(0.75)
                } else if (privModel.state == .matchedOne) {
                    Text("Great work! Now it's time to match without the guide. When you're ready, tap the camera preview to start the timer.")
                        .font(.headline)
                        .lineLimit(5)
                        .multilineTextAlignment(.leading)
                        .padding(10)
                        .padding(.horizontal, 10)
                        .background(Color(UIColor.tertiarySystemGroupedBackground).cornerRadius(25))
                        .frame(width: 300)
                } else if (privModel.state == .finished) {
                    VStack {
                        Text("Great work!\n\n\nResults:\n\nWith aid: \(privModel.timeToString(privModel.withAidResult))\nWithout aid: \(privModel.timeToString(privModel.noAidResult))")
                            .font(.headline)
                            .lineLimit(100)
                            .multilineTextAlignment(.leading)
                            .padding(10)
                            .padding(.horizontal, 10)
                            .background(Color(UIColor.tertiarySystemGroupedBackground).cornerRadius(25))
                            .frame(width: 300)
                        
                        Button(action: {
                            model.logResults(entry, privModel.withAidResult!, privModel.noAidResult!)
                            model.next()
                            privModel.reset()
                        }) {
                            Text("Next Item")
                                .font(.headline)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.blue.clipShape(RoundedRectangle(cornerRadius: 50)))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding()
                    }
                }
            
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
    }
}
