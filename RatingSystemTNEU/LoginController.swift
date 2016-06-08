//
//  LoginController.swift
//  RatingSystemTNEU
//
//  Created by dimakomar on 11/3/15.
//  Copyright © 2015 Dima Komar. All rights reserved.
//

import UIKit
import QuartzCore
import SVProgressHUD
import ReachabilitySwift


let useClosures = false
class LoginController: UITableViewController {
    
    //MARK: Outlets for UI Elements.
    @IBOutlet weak var usernameField:   UITextField!
    @IBOutlet weak var passwordField:   UITextField!
    @IBOutlet weak var mySwitch: UISwitch!
    @IBOutlet weak var loginButton: UIButton!

    var reachability: Reachability?
    var firstSemesterSubjectArray = [FirstSemestrSubject]()
    var secondSemesterSubjectArray = [FirstSemestrSubject]()
    var decodedFirstSemesterSubjectArray = [FirstSemestrSubject]()
    var decodedSecondSemesterSubjectArray = [FirstSemestrSubject]()
    var subjects = [String]()
    //MARK: Global Variables for Changing Image Functionality.
    private var idx: Int = 0
    
    var secondRunLoop = false
    var someKingOfError = false
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    //MARK: View Controller LifeCycle
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        setupReachability()
        
        SVProgressHUD.setBackgroundColor(UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 0.6))
        SVProgressHUD.setForegroundColor(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1))
        
        usernameField.addTarget(self, action: "textFieldDidChange", forControlEvents: UIControlEvents.EditingChanged)
        passwordField.addTarget(self, action: "textFieldDidChange", forControlEvents: UIControlEvents.EditingChanged)
        
        // Visual Effect View for background
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark)) as UIVisualEffectView
        visualEffectView.frame = self.view.frame
        visualEffectView.alpha = 0.5
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Disabled)
        
        for view in tableView.subviews {
            if view is UIScrollView {
                (view as? UIScrollView)!.delaysContentTouches = false
                break
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let myOutputUsername = NSUserDefaults.standardUserDefaults().objectForKey("Username")
        let myOutputPassword = NSUserDefaults.standardUserDefaults().objectForKey("Password")
        
        if (myOutputUsername != nil && myOutputPassword != nil)
        {
            
            self.usernameField.text = myOutputUsername as? String
            self.passwordField.text = myOutputPassword as? String
            self.mySwitch.on =  true
        }

        if usernameField.text!.isEmpty || passwordField.text!.isEmpty
            
        {
            self.loginButton(false)
        }
        else
        {
            self.loginButton(true)
        }

    }
    
    func textFieldDidChange() {
        
        
        
        if usernameField.text!.isEmpty || passwordField.text!.isEmpty
            
        {
    	        self.loginButton(false)
        }
        else
        {
            self.loginButton(true)
        }
        
    }
    
    
    func loginButton(enabled: Bool) -> () {
        func enable(){
            
            UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.loginButton.enabled = true
                }, completion: nil)
    
            
        }
        func disable(){
            
            UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.loginButton.enabled = false
                }, completion: nil)
        }
        return enabled ? enable() : disable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func buttonPressed(sender: AnyObject) {
        let stringAll = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789_."
        var isUsernameEng = true
        var isPasswrodEng = true
        
        for  char : Character in (self.usernameField.text?.characters)! {
          
            if !stringAll.containsString(String(char)) {
                isUsernameEng = false
            }
            
        }
        
        
        
        for  char : Character in (self.passwordField.text?.characters)! {
            
            if !stringAll.containsString(String(char)) {
                isPasswrodEng = false
            }
            
        }
        
        if mySwitch.on  {
            let username = self.usernameField.text
            let password = self.passwordField.text
            NSUserDefaults.standardUserDefaults().setObject(username, forKey:"Username")
            NSUserDefaults.standardUserDefaults().setObject(password, forKey:"Password")
            NSUserDefaults.standardUserDefaults().synchronize()
        } else {
            NSUserDefaults.standardUserDefaults().removeObjectForKey("Username")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("Password")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
            if isUsernameEng && isPasswrodEng {
                if self.reachability!.isReachable() {
                SVProgressHUD.show()
                let instance = SubjectMaker()
                    
                instance.request(self.usernameField.text!, password:self.passwordField.text!) { firstSemesterSubjectArray, secondSemesterSubjectArray, success, server in
                    
                    if server == false {
                        print("refreshed")
                        
                        
                        if let decodedFirst  = self.userDefaults.objectForKey("first") as? NSData {
                            self.decodedFirstSemesterSubjectArray = NSKeyedUnarchiver.unarchiveObjectWithData(decodedFirst) as! [FirstSemestrSubject]
                        }
                        if let decodedSecond  = self.userDefaults.objectForKey("second") as? NSData {
                            self.decodedSecondSemesterSubjectArray = NSKeyedUnarchiver.unarchiveObjectWithData(decodedSecond) as! [FirstSemestrSubject]
                        }
                        
                        self.someKingOfError = true
                        let alertController1 = UIAlertController(title: "Технічні роботи на mod.tanet", message: "Please try again in 5 seconds", preferredStyle: .Alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                            UIAlertAction in
                            NSLog("OK Pressed")
                        }
                        
                        
                        alertController1.addAction(okAction)
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            SVProgressHUD.dismiss()
                            if self.decodedFirstSemesterSubjectArray.count > 0 {
                                
                                self.performSegueWithIdentifier("Login", sender: self)
                                
                            } else {
                            self.secondRunLoop = true
                            self.performSelector(Selector("buttonPressed:"), withObject: self, afterDelay: 0.1)
                            
                            }
                        }
                    }
                    
                    if success    {
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            
                            if firstSemesterSubjectArray.count > 0 {
                            let first = NSKeyedArchiver.archivedDataWithRootObject(firstSemesterSubjectArray)
                            self.userDefaults.setObject(first, forKey: "first")
                            let second = NSKeyedArchiver.archivedDataWithRootObject(secondSemesterSubjectArray)
                            self.userDefaults.setObject(second, forKey: "second")
                            self.userDefaults.synchronize()
                            
                            if let decodedFirst  = self.userDefaults.objectForKey("first") as? NSData {
                                self.decodedFirstSemesterSubjectArray = NSKeyedUnarchiver.unarchiveObjectWithData(decodedFirst) as! [FirstSemestrSubject]
                            }
                            if let decodedSecond  = self.userDefaults.objectForKey("second") as? NSData {
                                self.decodedSecondSemesterSubjectArray = NSKeyedUnarchiver.unarchiveObjectWithData(decodedSecond) as! [FirstSemestrSubject]
                            }

                            self.firstSemesterSubjectArray = firstSemesterSubjectArray
                            self.secondSemesterSubjectArray = secondSemesterSubjectArray
                            } else {
                                if self.decodedFirstSemesterSubjectArray.count > 0 {
                                    self.firstSemesterSubjectArray = self.decodedFirstSemesterSubjectArray
                                    self.secondSemesterSubjectArray = self.decodedSecondSemesterSubjectArray
                                } else {
                                    let alertController1 = UIAlertController(title: "Технічні роботи на mod.tanet", message: "Please try again in 5 seconds", preferredStyle: .Alert)
                                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                                        UIAlertAction in
                                        NSLog("OK Pressed")
                                    }
                                    alertController1.addAction(okAction)
                                    self.presentViewController(alertController1, animated: true, completion: nil)
                                }
                                
                            }
                            if self.decodedFirstSemesterSubjectArray.count > 0 {

                            self.performSegueWithIdentifier("Login", sender: self)
                            SVProgressHUD.dismiss()
                            } else {
                                let alertController1 = UIAlertController(title: "Технічні роботи на mod.tanet", message: "Please try again in 5 seconds", preferredStyle: .Alert)
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                                    UIAlertAction in
                                    NSLog("OK Pressed")
                                }
                                alertController1.addAction(okAction)
                                
                                self.presentViewController(alertController1, animated: true, completion: nil)
                            }
                        }
                    } else if !self.secondRunLoop {
                        
                        let alertController1 = UIAlertController(title: "Неправильний логін або пароль", message: "Incorrect login and password", preferredStyle: .Alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                            UIAlertAction in
                            NSLog("OK Pressed")
                        }
                        
                        alertController1.addAction(okAction)
                         NSOperationQueue.mainQueue().addOperationWithBlock {
                        SVProgressHUD.dismiss()
                            if !self.secondRunLoop {
                        self.presentViewController(alertController1, animated: true, completion: nil)
                            }
                            }
                        }
                    
                }
                } else {
                    SVProgressHUD.dismiss()
                    let alertController = UIAlertController(title: "Please connect network", message: "Incorrect login and password", preferredStyle: .Alert)
                    
                    // Create the actions
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                    }
                    
                    alertController.addAction(okAction)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
            } else {
                SVProgressHUD.dismiss()
                let alertController = UIAlertController(title: "Недопустимий символ в логіні чи паролі", message: "Incorrect login or password", preferredStyle: .Alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                }
                
                alertController.addAction(okAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        
        }

    deinit {
        
        reachability?.stopNotifier()
        if (!useClosures) {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: ReachabilityChangedNotification, object: nil)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first
        
        if touch?.phase == UITouchPhase.Began {
          self.usernameField.resignFirstResponder()
          self.passwordField.resignFirstResponder()
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destView: SubjectViewController = segue.destinationViewController as! SubjectViewController
        
        
            destView.firstSemesterSubjectArray = self.decodedFirstSemesterSubjectArray
            destView.secondSemesterSubjectArray = self.decodedSecondSemesterSubjectArray
            destView.dataSource = self.decodedFirstSemesterSubjectArray

        
    }
    
    @IBAction func backgroundPressed(sender: AnyObject) {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
    }
    
     func setupReachability() {
        do {
            self.reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Cannot setup reachability monitoring")
            return
        }
        
        self.reachability!.whenReachable = { reachability in

        }
        self.reachability!.whenUnreachable = { reachability in
       
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        do {
            
            try self.reachability!.startNotifier() } catch {
            print("Cannot start reachability monitoring")
            return
        }
        }
        print("Started reachability")
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

}

//Extension for Color to take Hex Values


extension UIColor{
    
    class func colorWithHex(hex: String, alpha: CGFloat = 1.0) -> UIColor {
        var rgb: CUnsignedInt = 0;
        let scanner = NSScanner(string: hex)
        
        if hex.hasPrefix("#") {
            // skip '#' character
            scanner.scanLocation = 1
        }
        scanner.scanHexInt(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0xFF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0xFF) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}





