//
//  FeedViewController.swift
//  MusiciansWanted
//
//  Created by Nick on 3/7/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FeedViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var refreshToken = ""
    var tableViewDataSource = FeedViewDataManager()
    
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
        
        tableViewDataSource.feedDelegate = self
        tableViewDataSource.getNotifications(MusiciansWanted.userId)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("IN CELL")
        var cell: FeedViewTableCell = tableView.dequeueReusableCellWithIdentifier("FeedViewCell") as! FeedViewTableCell
        
        let index = indexPath.row
        let notification = tableViewDataSource.getNotification(index)
        
        cell.titleLabel.text = notification.title
        cell.dateLabel.text = notification.date
        cell.locationLabel.text = notification.location
        cell.iconForCell.image = UIImage(named: notification.imageString)
        cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
        cell.contentView.layer.borderWidth = 0.4
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("here")
        println(tableViewDataSource.rows())
        return tableViewDataSource.rows()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90.0
    }
    
    func addedNewItem(item: Notification) {
        println("reloading")
        tableView.reloadData()
    }
}