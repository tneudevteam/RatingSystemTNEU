//
//  ModuleView.swift
//  RatingSystemTNEU
//
//  Created by Dima Komar on 11/4/15.
//  Copyright © 2015 Dima Komar. All rights reserved.
//

import UIKit
import QuartzCore

class ModuleView: UIView {

    override init (frame : CGRect) {
        super.init(frame : frame)
    }
        
    convenience init (initWithSubjectModules:[SubjectsModules], actualDataSource: FirstSemestrSubject, andFrame: CGRect ) {
        self.init(frame:CGRect.zero)
        
        
        let woView = UIView(frame: andFrame)
        
        
        
        woView.backgroundColor = UIColor.clearColor()

            let subjectName = UILabel(frame: CGRectZero)
            let totalScore = UILabel(frame: CGRectZero)
            let controlType = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))

            subjectName.textColor = UIColor.whiteColor()
            subjectName.text = actualDataSource.subjectName
            subjectName.font = UIFont(name: "AvenirNext-UltraLight", size: 18)
            subjectName.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
            subjectName.numberOfLines = 3
            subjectName.translatesAutoresizingMaskIntoConstraints = false
        
            totalScore.textColor = UIColor.whiteColor()
            totalScore.text = String(actualDataSource.totalScore)
            totalScore.font = UIFont(name: "AvenirNext-UltraLight", size: 67)
            totalScore.translatesAutoresizingMaskIntoConstraints = false
            totalScore.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        
            switch (actualDataSource.controlType) {
            case "Залік" : controlType.image = UIImage(named: "zalik")
            case "Екзамен" : controlType.image = UIImage(named: "exam")
            case "Курсова робота", "Курсовий проект" : controlType.image = UIImage(named: "kurs")
            case "Дипломна робота" : controlType.image = UIImage(named: "diploma")
            case "Звіт про практику" : controlType.image = UIImage(named: "practice")
            default : controlType.image = UIImage(named: "none")
            }
        
            controlType.translatesAutoresizingMaskIntoConstraints = false
        
        dispatch_async(dispatch_get_main_queue()) {
            woView.addSubview(subjectName)
            woView.addSubview(totalScore)
            woView.addSubview(controlType)
        }
        
        
       
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {

        let trailingToType = NSLayoutConstraint(item: totalScore, attribute: .Trailing , relatedBy: .Equal, toItem: controlType, attribute: .Trailing, multiplier: 1, constant: -15)

        
        let controlTypeToScoreConstraint = NSLayoutConstraint(item: controlType, attribute: .Top, relatedBy: .Equal, toItem: totalScore, attribute: .Bottom, multiplier: 1, constant: -25)
        
        let controlTypeTrailing = NSLayoutConstraint(item: controlType, attribute: .TrailingMargin , relatedBy: .Equal, toItem: woView, attribute: .Trailing, multiplier: 1, constant: -5)
        
        let widthConstraint = NSLayoutConstraint(item: controlType, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
        
        let heightConstraint = NSLayoutConstraint(item: controlType, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)

        
        let subjectNameLeading = NSLayoutConstraint(item: subjectName, attribute: .Leading , relatedBy: .Equal, toItem: woView, attribute: .LeadingMargin, multiplier: 1, constant: -5)
        let subjectNameTrailing = NSLayoutConstraint(item: subjectName, attribute: .Trailing , relatedBy: .Equal, toItem: woView, attribute: .TrailingMargin, multiplier: 1, constant: -70)
        let subjectNameTop = NSLayoutConstraint(item: subjectName, attribute: .TopMargin, relatedBy: .Equal, toItem: woView, attribute: .TopMargin, multiplier: 1, constant: 8)

            dispatch_async(dispatch_get_main_queue()) {
        woView.addConstraints([widthConstraint, heightConstraint, controlTypeToScoreConstraint, controlTypeTrailing, subjectNameLeading, subjectNameTrailing, subjectNameTop, trailingToType])
            }
        }
    
        

        var scoreConstant: CGFloat = 0
        for (_, index) in initWithSubjectModules.enumerate()  {

            let score = UIButton(frame: CGRectZero)
            let date = UILabel(frame: CGRectZero)
            let weight = UILabel(frame: CGRectZero)
            let dateString = index.date
            let shortDate = String(dateString.characters.dropLast(3))

            
            score.layer.cornerRadius = score.bounds.size.width / 2.0
            score.clipsToBounds = true
            
            //score.backgroundColor = UIColor(patternImage: UIImage(named: "dd1")!)
            score.setTitle(String(index.score), forState: .Normal)
            score.layer.contents = UIImage(named: "dd16")?.CGImage
            
            score.titleLabel?.textColor = UIColor.whiteColor()
            
            score.titleLabel?.font = UIFont(name: "Arial", size: 20)
            score.translatesAutoresizingMaskIntoConstraints = false
                
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            date.text = shortDate
            date.font = UIFont(name: "Arial", size: 15)
            date.translatesAutoresizingMaskIntoConstraints = false

            date.textColor = UIColor.whiteColor()
            weight.textColor = UIColor.whiteColor()
            weight.text = String(index.weight) + String("%")
            weight.font = UIFont(name: "Arial", size: 15)
            weight.translatesAutoresizingMaskIntoConstraints = false
            }
            woView.addSubview(weight)
            woView.addSubview(score)
            woView.addSubview(date)
            

            dispatch_async(dispatch_get_main_queue()) {
            let dateLeading = NSLayoutConstraint(item: date, attribute: .Leading , relatedBy: .Equal, toItem: woView, attribute: .LeadingMargin, multiplier: 1, constant: scoreConstant - 7)
            let dateBottom = NSLayoutConstraint(item: woView, attribute: .BottomMargin, relatedBy: .Equal, toItem: date, attribute: .Bottom, multiplier: 1, constant: 18)
            
            let weightLeading = NSLayoutConstraint(item: weight, attribute: .Leading , relatedBy: .Equal, toItem: woView, attribute: .LeadingMargin, multiplier: 1, constant: scoreConstant - 2)
            let weightBottom = NSLayoutConstraint(item: woView, attribute: .BottomMargin, relatedBy: .Equal, toItem: weight, attribute: .Bottom, multiplier: 1, constant: 4)
            
            let scoreLeading = NSLayoutConstraint(item: score, attribute: .Leading , relatedBy: .Equal, toItem: woView, attribute: .LeadingMargin, multiplier: 1, constant: scoreConstant - 5)
            let scoreBottom = NSLayoutConstraint(item: woView, attribute: .BottomMargin, relatedBy: .Equal, toItem: score, attribute: .Bottom, multiplier: 1, constant: 36)


            scoreConstant += 47
            woView.addConstraints([dateLeading, dateBottom, weightLeading, weightBottom, scoreLeading, scoreBottom])
            }
        }
        
        
        
        dispatch_async(dispatch_get_main_queue()) {

                self.addSubview(woView)
            }
    
    }
    
    
    override func awakeFromNib() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
    }

    
}
