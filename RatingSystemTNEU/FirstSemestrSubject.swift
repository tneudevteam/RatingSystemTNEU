//
//  FirstSemestrSubject.swift
//  RatingSystemTNEU
//
//  Created by Dima Komar on 11/2/15.
//  Copyright © 2015 Dima Komar. All rights reserved.
//

import Foundation

class FirstSemestrSubject: NSObject, NSCoding {
    var groupName : String
    var studentName : String
    var subjectName : String
    var controlType: String
    var totalScore: Int
    var modulesArr: [SubjectsModules]!
    
    init(modulesArr: [SubjectsModules], groupName: String, studentName: String,subjectName: String, controlType: String, totalScore: Int) {
        self.modulesArr = modulesArr
        self.groupName = groupName
        self.studentName = studentName
        self.subjectName = subjectName
        self.controlType = controlType
        self.totalScore = totalScore
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let totalScore = aDecoder.decodeIntegerForKey("totalScore")
        let studentName = aDecoder.decodeObjectForKey("studentName") as! String
        let groupName = aDecoder.decodeObjectForKey("groupName") as! String
        let subjectName = aDecoder.decodeObjectForKey("subjectName") as! String
        let controlType = aDecoder.decodeObjectForKey("controlType") as! String
        let modulesArr = aDecoder.decodeObjectForKey("modulesArr") as! [SubjectsModules]
        
        self.init(modulesArr: modulesArr, groupName: groupName, studentName: studentName,   subjectName: subjectName,  controlType:controlType, totalScore: totalScore)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeInteger(totalScore, forKey: "totalScore")
        aCoder.encodeObject(studentName, forKey: "studentName")
        aCoder.encodeObject(groupName, forKey: "groupName")
        aCoder.encodeObject(subjectName, forKey: "subjectName")
        aCoder.encodeObject(controlType, forKey: "controlType")
        aCoder.encodeObject(modulesArr, forKey: "modulesArr")
    }
}
