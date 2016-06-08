//
//  SubjectMaker.swift
//  RatingSystemTNEU
//
//  Created by Dima Komar on 11/2/15.
//  Copyright © 2015 Dima Komar. All rights reserved.
//

import Foundation


class SubjectMaker {
    
    var firstSemesterSubjectArray = [FirstSemestrSubject]()
    var firstSemesterModulesArray = [SubjectsModules]()
    
    var secondSemesterSubjectArray = [FirstSemestrSubject]()
    var secondSemesterModulesArray = [SubjectsModules]()
    func request(login: String, password: String, completion: (([FirstSemestrSubject], [FirstSemestrSubject], Bool, Bool ) -> Void)) {
        
        let url = NSURL(string: "https://moduleok.appspot.com/api/getScoresByPassword?login=\(login)&password=\(password)")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {  (data, response, error) in
            
            if error != nil {
                print("error != nil")
                print(error)
                completion(self.firstSemesterSubjectArray, self.secondSemesterSubjectArray, false, false)
            } else {
            
            do {
            let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                if let student = jsonData["student"] as? NSDictionary {
                    
                    if let name = student["name"] as? String {
                        if let group = student["group"] as? String {                            
                            if let firstSemestr = student["firstSemester"] as? NSDictionary {
                                if let subjects = firstSemestr["subjects"] as? NSArray {
                                    for subject in subjects {
                                        if let subjName = subject["name"] as? String {
                                            if let controlType = subject["controlType"] as? String {
                                                if let totalScore = subject["totalScore"] as? Int {
                                                    if let modules = subject["modules"] as? NSArray {
                                                        for module in modules {
                                                            if let date = module["date"] as? String {
                                                                if let weight = module["weight"] as? Int {
                                                                    if let score = module["score"] as? Int {
                                                                        
                                                                        self.firstSemesterModulesArray.append(SubjectsModules(date: date, weight: weight, score: score))
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        self.firstSemesterSubjectArray.append(FirstSemestrSubject(modulesArr: self.firstSemesterModulesArray, groupName: group, studentName: name, subjectName: subjName, controlType: controlType, totalScore: totalScore ))
                                                        self.firstSemesterModulesArray = [SubjectsModules]()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            if let secondSemester = student["secondSemester"] as? NSDictionary {
                                if let subjects = secondSemester["subjects"] as? NSArray {
                                    for subject in subjects {
                                        if let subjName = subject["name"] as? String {
                                            if let controlType = subject["controlType"] as? String {
                                                if let totalScore = subject["totalScore"] as? Int {
                                                    if let modules = subject["modules"] as? NSArray {
                                                        for module in modules {
                                                            if let date = module["date"] as? String {
                                                                if let weight = module["weight"] as? Int {
                                                                    if let score = module["score"] as? Int {
                                                                        
                                                                        self.secondSemesterModulesArray.append(SubjectsModules(date: date, weight: weight, score: score))
                                                                        print(self.secondSemesterModulesArray)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        self.secondSemesterSubjectArray.append(FirstSemestrSubject(modulesArr: self.secondSemesterModulesArray, groupName: group, studentName: name, subjectName: subjName, controlType: controlType, totalScore: totalScore ))
                                                        self.secondSemesterModulesArray = [SubjectsModules]()
                                                    }
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                                
                            }
                            
                        }
                    }
                }
            if let success = jsonData["success"] as? Bool {
                completion(self.firstSemesterSubjectArray, self.secondSemesterSubjectArray, success, true)

                
            }
                
            } catch {
                completion(self.firstSemesterSubjectArray, self.secondSemesterSubjectArray, false, false)
                }
            }
                    }
       

        task.resume()
    
      
        
    }
}
