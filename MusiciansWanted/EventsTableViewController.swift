//
//  EventsTableViewController.swift
//  MW
//
//  Created by hankharvey on 4/6/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController {
    
    var pressed = false;
    
    var eventAmount = 10;
    
    @IBAction func reloadTable(sender: UIBarButtonItem) {
        pressed = true;
        eventAmount += 10;
        eventManager.loadEvents(0,upper: eventAmount);
        tableView.reloadData()
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        eventManager.loadEvents(0,upper: eventAmount);
        tableView.reloadData()
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

        var event = eventManager.event[indexPath.row]
        
        if(pressed == false)
        {
            cell.EventDescription.text = "Please wait a second, then press the refresh button to get new events. Thanks!"
            
        } else {
            // Configure the cell...
            cell.EventDescription.text = event.eventLocation
            //cell.EventImage.image = event.eventPicture
            //cell.EventTitle.text = event.eventName
            
            //cell.EventDescription.text = "The time to see ultra lord"
            cell.EventImage.image = UIImage(named: "UltraLord")
            cell.EventTitle.text = "The Event"
        }
        
        
        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
