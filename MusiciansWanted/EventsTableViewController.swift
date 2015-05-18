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
        
        
        eventManager.eventDelegate = self
//      tableView.reloadData()
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
        cell.EventTitle.text = event!.eventName
        
        //cell.EventDescription.text = "The time to see ultra lord"
        
        if (event!.hasEventPic == "true")
        {
            var url = "/api/s3EventGet?event_id=\(event!.eventId)"
            
            DataManager.makeGetRequest(url, completion: { (data, error) -> Void in
                if data != nil {
                    var eventjson = JSON(data: data!)
                    if eventjson["picture"] != nil {
                        var base64String = eventjson["picture"].stringValue
                        
                        let decodedString = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                        var downloadedImage = UIImage(data: decodedString!)!
                        var newImage = Toucan(image: downloadedImage).resize(CGSizeMake(280, 140), fitMode: Toucan.Resize.FitMode.Scale).image
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            cell.EventImage.image = newImage
                           
                            //self.events[id].eventPicture = newImage;
                            
                        }
                    }
                }
                
            })
            
        } else {
            cell.EventImage.image = event!.eventPicture
            
        }
        
        return cell
    }
    
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
        
        //println("Instantiate event view...")
        let eventView = self.storyboard?.instantiateViewControllerWithIdentifier("EventViewController") as! EventViewController
        
        eventView.controller = "events"
        if (event!.hasEventPic == "true")
        {
            var url = "/api/s3EventGet?event_id=\(event!.eventId)"
            
            DataManager.makeGetRequest(url, completion: { (data, error) -> Void in
                if data != nil {
                    var eventjson = JSON(data: data!)
                    if eventjson["picture"] != nil {
                        var base64String = eventjson["picture"].stringValue
                        
                        let decodedString = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                        var downloadedImage = UIImage(data: decodedString!)!
                        var newImage = Toucan(image: downloadedImage).resize(CGSizeMake(280, 140), fitMode: Toucan.Resize.FitMode.Scale).image
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            eventView.icon = newImage
                            //self.events[id].eventPicture = newImage;
                            
                        }
                    }
                }
            })
            
        } else {
            eventView.icon = event!.eventPicture
        }
        
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
