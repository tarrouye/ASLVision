//
//  AlphabetEntry.swift
//  ASLVision
//
//  Created by Théo Arrouye on 2/20/21.
//

import Foundation

class AlphabetEntryScores : Hashable, Codable, ObservableObject {
    @Published var withAidTotal : TimeInterval?
    @Published var withAidCount : Int?
    @Published var noAidTotal : TimeInterval?
    @Published var noAidCount : Int?
    
    static func == (lhs: AlphabetEntryScores, rhs: AlphabetEntryScores) -> Bool {
        return lhs.withAidTotal == rhs.withAidTotal && lhs.withAidCount == rhs.withAidCount && lhs.noAidTotal == rhs.noAidTotal && lhs.noAidCount == rhs.noAidCount
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(withAidTotal)
        hasher.combine(withAidCount)
        hasher.combine(noAidTotal)
        hasher.combine(noAidCount)
    }
    
    enum CodingKeys : String, CodingKey {
        case withAidTotal, withAidCount, noAidTotal, noAidCount
    }
    
    init() {
        self.withAidTotal = nil
        self.withAidCount = nil
        self.noAidCount =  nil
        self.noAidTotal = nil
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        withAidTotal = try values.decode(TimeInterval.self, forKey: .withAidTotal)
        withAidCount = try values.decode(Int.self, forKey: .withAidCount)
        noAidTotal = try values.decode(TimeInterval.self, forKey: .noAidTotal)
        noAidCount = try values.decode(Int.self, forKey: .noAidCount)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(withAidTotal, forKey: .withAidTotal)
        try container.encode(withAidCount, forKey: .withAidCount)
        try container.encode(noAidTotal, forKey: .noAidTotal)
        try container.encode(noAidCount, forKey: .noAidCount)
    }
}

class AlphabetEntry : Hashable, Codable, ObservableObject {
    static func == (lhs: AlphabetEntry, rhs: AlphabetEntry) -> Bool {
        return lhs.char == rhs.char
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(char)
    }
    
    var char : String
    @Published var scores : AlphabetEntryScores?
    // .... (image, model, metc)
    
    func avg(_ time: TimeInterval?, _ count: Int?) -> TimeInterval? {
        if let total = time, let count = count {
            return total / Double(count)
        }
        
        return nil
    }
    
    @Published var avgWithAid : TimeInterval? = nil
    
    @Published var avgWithoutAid: TimeInterval? = nil
    
    init(char: String) {
        self.char = char
        
        // look for info in file directory
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let pathWithFileName = documentDirectory.appendingPathComponent("ALPHABET_SCORES_\(char.uppercased())")
            do {
                let data = try Data(contentsOf: pathWithFileName, options: .mappedIfSafe)
                let results = try JSONDecoder().decode(AlphabetEntryScores.self, from: data)
                self.scores = results
                self.avgWithAid = self.avg(self.scores?.withAidTotal!, self.scores?.withAidCount!)
                self.avgWithoutAid = self.avg(self.scores?.noAidTotal!, self.scores?.noAidCount!)
            } catch {
                //  error
            }
        }
    }
    
    enum CodingKeys : String, CodingKey {
        case char
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        char = try values.decode(String.self, forKey: .char)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(char, forKey: .char)
    }
    
    func updateScores(_ withAid : TimeInterval, _ withoutAid : TimeInterval) {
        if (self.scores == nil) {
            self.scores = AlphabetEntryScores()
        }
        
        if (self.scores!.withAidCount == nil) {
            self.scores!.withAidCount = 1
        } else {
            self.scores?.withAidCount! += 1
        }
        
        if (self.scores!.noAidCount == nil) {
            self.scores!.noAidCount = 1
        } else {
            self.scores?.noAidCount! += 1
        }
        
        if (self.scores!.withAidTotal == nil) {
            self.scores!.withAidTotal = withAid
        } else {
            self.scores?.withAidTotal! += withAid
        }
        
        if (self.scores!.noAidTotal == nil) {
            self.scores!.noAidTotal = withoutAid
        } else {
            self.scores?.noAidTotal! += withoutAid
        }
        
        self.avgWithAid = self.avg(self.scores?.withAidTotal!, self.scores?.withAidCount!)
        self.avgWithoutAid = self.avg(self.scores?.noAidTotal!, self.scores?.noAidCount!)
        
        self.saveDataToFile()
    }
    
    func saveDataToFile() {
        do {
            let jsonData = try JSONEncoder().encode(self.scores)
            
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let pathWithFileName = documentDirectory.appendingPathComponent("ALPHABET_SCORES_\(char.uppercased())")
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
}
