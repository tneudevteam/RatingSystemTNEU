//
//  SubjectsModules.swift
//  RatingSystemTNEU
//
//  Created by Dima Komar on 11/2/15.
//  Copyright © 2015 Dima Komar. All rights reserved.
//

import Foundation

class  SubjectsModules: NSObject, NSCoding {
    var date : String
    var weight : Int
    var score: Int
    
    init(date: String , weight: Int, score: Int) {
        self.date = date
        self.weight = weight
        self.score = score
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let weight = aDecoder.decodeIntegerForKey("weight")
        let score = aDecoder.decodeIntegerForKey("score")
        let date = aDecoder.decodeObjectForKey("date") as! String
        
        
        self.init(date:date, weight: weight,score: score)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(score, forKey: "score")
        aCoder.encodeInteger(weight, forKey: "weight")
        aCoder.encodeObject(date, forKey: "date")
        
    }

}