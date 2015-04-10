//
//  FeedViewController.swift
//  MusiciansWanted
//
//  Created by Nick on 3/7/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var refreshToken = ""
    var tableViewDataSource = FeedViewDataManager()
    
    override func viewWillAppear(animated: Bool) {
        tableViewDataSource.getNotifications(MusiciansWanted.userId)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let needToDisplayLocationservices = MusiciansWanted.locationServicesDisabled {
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: FeedViewTableCell = tableView.dequeueReusableCellWithIdentifier("FeedCell") as! FeedViewTableCell
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}