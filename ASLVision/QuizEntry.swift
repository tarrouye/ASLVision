//
//  QuizResultEntry.swift
//  ASLVision
//
//  Created by Théo Arrouye on 2/20/21.
//

import Foundation

struct QuizResultEntry : Hashable, Codable {
    var alphabet_entry : AlphabetEntry
    var matchTimeWithAid : TimeInterval
    var matchTimeWithoutAid : TimeInterval
    
    enum CodingKeys : String, CodingKey {
        case alphabet_entry, matchTimeWithAid, matchTimeWithoutAid
    }
    
    init(alphabet_entry: AlphabetEntry, matchTimeWithAid: TimeInterval, matchTimeWithoutAid: TimeInterval) {
        self.alphabet_entry = alphabet_entry
        self.matchTimeWithAid = matchTimeWithAid
        self.matchTimeWithoutAid = matchTimeWithoutAid
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        alphabet_entry = try values.decode(AlphabetEntry.self, forKey: .alphabet_entry)
        matchTimeWithAid = try values.decode(TimeInterval.self, forKey: .matchTimeWithAid)
        matchTimeWithoutAid = try values.decode(TimeInterval.self, forKey: .matchTimeWithoutAid)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(alphabet_entry, forKey: .alphabet_entry)
        try container.encode(matchTimeWithAid, forKey: .matchTimeWithAid)
        try container.encode(matchTimeWithoutAid, forKey: .matchTimeWithoutAid)
    }
}

struct QuizEntry : Identifiable, Equatable, Codable {
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
    
    enum CodingKeys : String, CodingKey {
        case id, date, results
    }
    
    init(id : UUID, date : Date, results: [QuizResultEntry]) {
        self.id = id
        self.date = date
        self.results = results
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        date = try values.decode(Date.self, forKey: .date)
        results = try values.decode([QuizResultEntry].self, forKey: .results)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        
        try container.encode(results, forKey: .results)
    }
}
