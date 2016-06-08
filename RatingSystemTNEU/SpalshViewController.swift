//
//  SpalshViewController.swift
//  RatingSystemTNEU
//
//  Created by Dima Komar on 11/13/15.
//  Copyright © 2015 Dima Komar. All rights reserved.
//

import UIKit

class SpalshViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        JTSplashView.splashViewWithBackgroundColor(UIColor.colorWithHex("#2391c0", alpha: 1), circleColor: UIColor.colorWithHex("#46a889", alpha: 1), circleSize: nil)
        
        JTSplashView.finishWithCompletion { () -> Void in
            UIApplication.sharedApplication().statusBarHidden = false
            
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.performSegueWithIdentifier("Login1", sender: self)
        // Simulate state when we want to hide the splash view

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
