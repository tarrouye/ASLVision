//
//  QuizResultEntry.swift
//  ASLVision
//
//  Created by Théo Arrouye on 2/20/21.
//

import Foundation

struct QuizResultEntry : Hashable {
    var alphabet_entry : AlphabetEntry
    var matchTimeWithAid : TimeInterval
    var matchTimeWithoutAid : TimeInterval
}

struct QuizEntry : Identifiable, Equatable {
    static func == (lhs: QuizEntry, rhs: QuizEntry) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: UUID
    var date : Date
    var results : [QuizResultEntry]
    
    var avgWithAid : TimeInterval {
        var total : TimeInterval = 0
        var count : Int = 0
        
        for res in results {
            total += res.matchTimeWithAid
            count += 1
        }
        
        return total / Double(count)
    }
    
    var avgWithoutAid : TimeInterval {
        var total : TimeInterval = 0
        var count : Int = 0
        
        for res in results {
            total += res.matchTimeWithoutAid
            count += 1
        }
        
        return total / Double(count)
    }
}
