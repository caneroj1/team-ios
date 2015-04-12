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

        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        tableViewDataSource.feedDelegate = self
        tableViewDataSource.getNotifications(MusiciansWanted.userId)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: FeedViewTableCell = tableView.dequeueReusableCellWithIdentifier("FeedViewCell") as! FeedViewTableCell
        
        let index = indexPath.row
        let notification = tableViewDataSource.getNotification(index)
        
        cell.titleLabel.text = notification.title
        cell.dateLabel.text = notification.date
        cell.locationLabel.text = notification.location
        cell.iconForCell.image = UIImage(named: notification.imageString)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSource.rows()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90.0
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let notification = tableViewDataSource.getNotification(indexPath.row)
        
        let personView = self.storyboard?.instantiateViewControllerWithIdentifier("PersonViewController") as! PersonViewController
        
        personView.id = notification.recordId
        
        self.navigationController?.pushViewController(personView, animated: true)
    }
    
    func addedNewItem(item: Notification) {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
}