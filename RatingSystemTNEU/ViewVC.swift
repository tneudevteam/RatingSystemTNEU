//
//  EmbededTableViewController.swift
//  RatingSystemTNEU
//
//  Created by dimakomar on 3/18/16.
//  Copyright © 2016 Dima Komar. All rights reserved.
//

import UIKit
import AVFoundation
import SafariServices


class ViewVC: UIViewController {
    @IBOutlet weak var devName: UIButton!
    @IBOutlet weak var playerLayer: VideoLayer!
    var url: NSURL!
    var videoAsset : AVAsset?
    
    func showDev() {
        if let url = NSURL(string: "https://vk.com/dima.komar") {
            if #available(iOS 9.0, *) {
                //                let vc = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
                //                presentViewController(vc, animated: false, completion: nil)
                
                let safariViewController = SFSafariViewController(URL: url)
                safariViewController.delegate = self
                
                // hide navigation bar and present safari view controller
                safariViewController.modalPresentationStyle = .OverCurrentContext
                safariViewController.providesPresentationContextTransitionStyle = true;
                safariViewController.definesPresentationContext = true;
                self.presentViewController(safariViewController, animated: true, completion: nil)
            } else {
                let openLink = NSURL(string : "https://vk.com/dima.komar")
                UIApplication.sharedApplication().openURL(openLink!)
            }
            
        }
    }
    
    @IBAction func devTouched(sender: UIButton) {
        showDev()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        modalTransitionStyle = .FlipHorizontal
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        self.devName.setTitleColor(UIColor.whiteColor(), forState: .Normal)

    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        switch arc4random_uniform(4) {
        case 0: self.url = NSBundle.mainBundle().URLForResource("1", withExtension: "mov")
        case 1: self.url = NSBundle.mainBundle().URLForResource("2", withExtension: "mov")
        case 2: self.url = NSBundle.mainBundle().URLForResource("3", withExtension: "mov")
        case 3: self.url = NSBundle.mainBundle().URLForResource("4", withExtension: "mov")
        default: 0
        }
        
        self.videoAsset = AVAsset(URL: url)
        self.playerLayer.setContentAsset(self.videoAsset!)
        
        self.playerLayer.play() { time in
            
            let maximumTime = self.videoAsset!.duration.value / Int64(self.videoAsset!.duration.timescale)
            
            if Int64(time) >= maximumTime {
                self.playerLayer.rewind(time: 0)
            }
            
        }

    }
}

extension ViewVC: SFSafariViewControllerDelegate {
    @available(iOS 9.0, *)
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        // pop safari view controller and display navigation bar again
        navigationController?.popViewControllerAnimated(true)
        navigationController?.navigationBarHidden = true
    }
    
}
