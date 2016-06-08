//
//  SubjectViewController.swift
//  RatingSystemTNEU
//
//  Created by dimakomar on 11/3/15.
//  Copyright © 2015 Dima Komar. All rights reserved.
//

import UIKit
import DGRunkeeperSwitch
import PullToMakeFlight
import AVFoundation

class SubjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var firstSemesterSubjectArray = [FirstSemestrSubject]()
    var secondSemesterSubjectArray = [FirstSemestrSubject]()
    var dataSource = [FirstSemestrSubject]()
    
    @IBOutlet weak var myTableView: UITableView!
    var subjects = [String]()
    var date = [SubjectsModules]()
    var realDate = [SubjectsModules]()
    var modulesDates = [String]()
    
    var modulesCounterArrayOfInt = [Int]()
    var modulesCounter = 0
    var moduleString: String!
    var modulesForSubjects = [[SubjectsModules]]()
    var flightSound:AVAudioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var woSwitch: DGRunkeeperSwitch!
    @IBOutlet weak var topView: UIView!
    

    @IBAction func switchChangedValue(sender: DGRunkeeperSwitch) {
        
        switch (sender.selectedIndex) {
        case 0:
        myTableView.reloadData()
        self.dataSource.removeAll()
        self.dataSource.appendContentsOf(self.firstSemesterSubjectArray)
        getModulesOutOf(self.dataSource)

        myTableView.reloadData()
        case 1:
        self.dataSource.removeAll()
        self.dataSource.appendContentsOf(self.secondSemesterSubjectArray)
        getModulesOutOf(self.dataSource)
        NSOperationQueue.mainQueue().addOperationWithBlock {
        self.myTableView.reloadData()
        }
        
        
        
        default: self.dataSource = self.secondSemesterSubjectArray
        myTableView.reloadData()
        
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
               
        if self.secondSemesterSubjectArray.count == 0 {
            self.woSwitch.enabled = false
            self.woSwitch.backgroundColor = UIColor.grayColor()
        } else {
            self.woSwitch.backgroundColor = UIColor(red: 0.133, green: 0.561, blue: 0.757, alpha: 1.0)
        }
        
        print("datasource: \(self.dataSource)")
        
        self.woSwitch.rightTitle = "2 Семетр"
        self.woSwitch.leftTitle = "1 Семестр"
        self.getModulesOutOf(self.dataSource)
        
        
        self.myTableView.backgroundColor = UIColor(red: 0.133, green: 0.561, blue: 0.757, alpha: 1.0)
        myTableView.registerNib(UINib(nibName: "CustomOneCell", bundle: nil), forCellReuseIdentifier: "CustomCellOne")
        myTableView.registerNib(UINib(nibName: "CustomLogOutCell", bundle: nil), forCellReuseIdentifier: "CustomLogOutCell")
        myTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.topView.backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1.0)
        self.myTableView.contentInset = UIEdgeInsetsMake(101, 0, 0, 0)
        myTableView.layoutIfNeeded()
        
        let flightSoundURL:NSURL = NSBundle.mainBundle().URLForResource("aircraft051", withExtension: "mp3")!
        
        myTableView.addPullToRefresh(PullToMakeFlight(), action: { () -> () in
            let delayTime = dispatch_time(DISPATCH_TIME_NOW,
                Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue(), {[unowned self] in
                self.myTableView.endRefreshing()
                self.flightSound = try! AVAudioPlayer(contentsOfURL: flightSoundURL, fileTypeHint: nil)
                self.flightSound.numberOfLoops = 0
                self.flightSound.prepareToPlay()
                self.flightSound.play()
                })
        })

    }
    
    
    func getModulesOutOf(semecter: [FirstSemestrSubject]) {
        self.modulesForSubjects.removeAll()
        for item in self.dataSource {
            
            for moduleInfo in item.modulesArr {
                
                self.moduleString = (moduleString ?? "") + "\(moduleInfo.date) |"
                self.date.append(moduleInfo)
                
            }
            self.modulesForSubjects.append(self.date)
            self.modulesCounterArrayOfInt.append(self.date.count)
            self.date = [SubjectsModules]()
            self.moduleString = ""
        }

    }

    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count + 1
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         dispatch_async(dispatch_get_main_queue()) {
        self.performSegueWithIdentifier("LogOut", sender: self)
        }
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == self.dataSource.count  {
            let cell = tableView.dequeueReusableCellWithIdentifier("CustomLogOutCell", forIndexPath: indexPath) as! CustomLogOutCell
            return cell
        } else {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let woView = ModuleView(initWithSubjectModules: modulesForSubjects[indexPath.row], actualDataSource: self.dataSource[indexPath.row], andFrame: CGRect(x: 0 , y: 0, width: cell.frame.width, height: cell.frame.height))
        // remove subviews
            
        for subview in cell.subviews{
            subview.removeFromSuperview()
            
        }
        
        var arrayOfColors = [UIColor(red: 0.5, green: 0.5, blue: 0.85, alpha: 1.0), UIColor(red: 0.87, green: 0.38, blue: 0.38, alpha: 1.0), UIColor(red: 0.882, green: 0.635, blue: 0.243, alpha: 1.0), UIColor(red: 0.294, green: 0.655, blue: 0.471, alpha: 1.0), UIColor(red: 0.706, green: 0.447, blue: 0.357, alpha: 1.0), UIColor(red: 0.5, green: 0.5, blue: 0.85, alpha: 1.0), UIColor(red: 0.3, green: 0.655, blue: 0.471, alpha: 1.0), UIColor(red: 0.882, green: 0.635, blue: 0.243, alpha: 1.0), UIColor(red: 0.294, green: 0.655, blue: 0.471, alpha: 1.0), UIColor(red: 0.706, green: 0.447, blue: 0.357, alpha: 1.0)]
        
        //cell.backgroundColor = UIColor.orangeColor()
        // then add your view
        cell.backgroundColor = arrayOfColors[indexPath.row]
        cell.addSubview(woView)
        return cell
            
        }   
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

        
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -30, 0, 0)
        cell.layer.transform = rotationTransform
        UIView.animateWithDuration(0.4, animations: { cell.layer.transform = CATransform3DIdentity })
        
    }
    
     func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row == self.dataSource.count {
            return true
        } else {
            return false
        }
    }
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == self.dataSource.count {
            return 80.0
        } else {
            return 160.0
        }
    }
    
}
