//
//  EventsTableViewController.swift
//  MW
//
//  Created by hankharvey on 4/6/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController, UIScrollViewDelegate, UITableViewDataSource, EventsDelegate {
    
    var eventAmount = 99;
    var eventManager = EventsManager()
    var refreshToken = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Loading More Events")
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl?.layer.zPosition = -1
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        eventManager.eventDelegate = self
//        tableView.reloadData()
    }

    override func viewWillAppear(animated: Bool) {
        eventManager.loadEvents(0,upper: eventAmount);

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        
        //Number of sections will have to be number of events currently loaded
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        
        //not clear on this, I'm thinking 1
        return eventManager.event.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Event", forIndexPath: indexPath) as! EventsCell

        var event = eventManager.eventDictionary[eventManager.event[indexPath.row]]
                
        // Configure the cell...
        var newLoc = event!.eventLocation.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        var tmpArray1 : [String] = newLoc.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: "\n:,"))
        
        if tmpArray1.count > 3 {
            newLoc = tmpArray1[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) + ", " + tmpArray1[2].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        }
        
        cell.EventDescription.text = newLoc
        //cell.EventImage.image = event.eventPicture
        cell.EventTitle.text = event!.eventName
            
        //cell.EventDescription.text = "The time to see ultra lord"
        cell.EventImage.image = UIImage(named: "UltraLord")
        //cell.EventTitle.text = "The Event"
        
        
        return cell
    }
    
    /*override func scrollViewDidScroll(scrollView: UIScrollView) {
        var currentOffset = scrollView.contentOffset.y;
        var maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= 20.0 && eventManager.isLoadingEvents == false) {
            println("expanding size");
           
            eventManager.isLoadingEvents = true
            eventManager.loadEvents(eventManager.event.count, upper: eventManager.event.count + 100)
        }
    }*/
    
    func addedNewEvent() {
        if self.refreshControl?.refreshing == true {
            self.refreshControl?.endRefreshing()
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let event = eventManager.eventDictionary[eventManager.event[indexPath.row]]
        
        println("Instantiate event view...")
        let eventView = self.storyboard?.instantiateViewControllerWithIdentifier("EventViewController") as! EventViewController
        
        eventView.controller = "events"
        eventView.icon = event!.eventPicture
        eventView.id = event!.eventId
        
        self.navigationController?.pushViewController(eventView, animated: true)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MapSegue" {
            let destination = segue.destinationViewController as! EventMapViewController
            destination.eventManager = eventManager
        }
    }
    
    // MARK: - Refresh Control
    func stopRefreshing() {
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: Refresh Control
    func refresh(sender: AnyObject) {
        eventManager.loadEvents(0,upper: eventAmount);
    }

}
