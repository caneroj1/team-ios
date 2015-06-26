//
//  FeedViewController.swift
//  MusiciansWanted
//
//  Created by Nick on 3/7/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController, UITableViewDataSource, FeedViewDelegate {
    var refreshToken = ""
    var tableViewDataSource = FeedViewDataManager()
    
    // MARK: Basic View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Loading More Notifications")
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl?.layer.zPosition = -1
        self.tableView.addSubview(self.refreshControl!)
        
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
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        tableViewDataSource.feedDelegate = self
        tableViewDataSource.getNotifications(MusiciansWanted.userId)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table View Functions
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("REMAKING CELLS")
        var cell: FeedViewTableCell = tableView.dequeueReusableCellWithIdentifier("FeedViewCell") as! FeedViewTableCell
        
        let index = indexPath.row
        let notification = tableViewDataSource.getNotification(index)
        
        cell.titleLabel.text = notification.title
        cell.dateLabel.text = notification.date
        cell.locationLabel.text = notification.location
        cell.iconForCell.image = UIImage(named: notification.imageString)
        
        
        let mobileAnalytics = AWSMobileAnalytics(forAppId: MobileAnalyticsAppId)
        let eventRecordClient = mobileAnalytics.eventClient
        let eventRecord = eventRecordClient.createEventWithEventType("FeedViewEvent")
        eventRecord.addAttribute("UserFeedView", forKey: "Feed")
        eventRecordClient.recordEvent(eventRecord)
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSource.rows()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var baseHeight: CGFloat = 90
        let notification = tableViewDataSource.getNotification(indexPath.row)
        
        if let rowLocation = notification.location {
            if count(rowLocation) > 40 {
                baseHeight += 10
            }
        }
        
        if count(notification.title) > 30 {
            baseHeight += 10
        }
        
        return baseHeight
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let notification = tableViewDataSource.getNotification(indexPath.row)
        
        if notification.notificationType >= 1 {
            let nextView = self.storyboard?.instantiateViewControllerWithIdentifier("PersonViewController") as! PersonViewController
            nextView.id = notification.recordId
            self.navigationController?.pushViewController(nextView, animated: true)
        }
    }
    
    
    // MARK: Feed View Delegate
    
    func addedNewItem() {
        if self.refreshControl?.refreshing == true {
            self.refreshControl?.endRefreshing()
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
    
    func stopRefreshing() {
        self.refreshControl?.endRefreshing()
    }
    
    func appliedFilters() {
        self.tableView.reloadData()
    }
    
    // MARK: Refresh Control
    
    func refresh(sender: AnyObject) {
        self.tableViewDataSource.refreshNotifications(MusiciansWanted.userId)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Feed Settings" {
            let destinationVC = segue.destinationViewController as! FeedSettingsTableViewController
            destinationVC.feedDataManager = self.tableViewDataSource
        }
    }
}