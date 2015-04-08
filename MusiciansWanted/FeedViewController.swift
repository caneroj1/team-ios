//
//  FeedViewController.swift
//  MusiciansWanted
//
//  Created by Nick on 3/7/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    var refreshToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let needToDisplayLocationservices = MusiciansWanted.locationServicesDisabled? {
            if needToDisplayLocationservices {
                let alertController = UIAlertController(
                    title: "Location Services Disabled",
                    message: "Location tracking allows us to provide more accurate search results for other users and events.",
                    preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                
                alertController.addAction(cancelAction)
                
                let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                    if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }
                alertController.addAction(openAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}