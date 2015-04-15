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
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorColor = UIColor.grayColor()
        tableViewDataSource.feedDelegate = self
        tableViewDataSource.getNotifications(MusiciansWanted.userId)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: FeedViewTableCell = tableView.dequeueReusableCellWithIdentifier("FeedViewCell") as! FeedViewTableCell
        
        let index = indexPath.row
        let notification = tableViewDataSource.getNotification(index)
        
        cell.titleLabel.text = notification.title
        cell.dateLabel.text = notification.date
        cell.locationLabel.text = notification.location
        cell.iconForCell.image = UIImage(named: notification.imageString)
        
        let mobileAnalytics = AWSMobileAnalytics(forAppId: "723abc951a394edea445c7b4babf1f7c")
        let eventRecordClient = mobileAnalytics.eventClient
        let eventRecord = eventRecordClient.createEventWithEventType("FeedViewEvent")
        
        eventRecord.addAttribute("Test", forKey: "Feed")
        
        eventRecordClient.recordEvent(eventRecord)
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSource.rows()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func addedNewItem(item: Notification) {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
}