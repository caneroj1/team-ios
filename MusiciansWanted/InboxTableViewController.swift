//
//  InboxTableViewController.swift
//  MW
//
//  Created by Nick on 4/3/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class InboxTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        //Sample data
        inboxMgr.addMessage("Bob", subject: "Hey Jim, just wanted to say hi", time: "Today")
        inboxMgr.addMessage("Robin Scherbatsky", subject: "What? That's not distracting. That's just talking about the story of a scrappy little underdog team that prevailed despite very shaky goal ending and, frankly, the declining skills of Trevor Linden.", time: "Today")
        inboxMgr.addMessage("Marco Polo", subject: "I found you.", time: "Today")
        inboxMgr.addMessage("Kari Gilbertson", subject: "Omg they are awesome", time: "Today")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return inboxMgr.messages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Msg", forIndexPath: indexPath) as InboxCell
        
        let message = inboxMgr.messages[indexPath.row]
       
        cell.lblProfName.text = message.name
        cell.lblBody.text = message.subject
        cell.lblDate.text = message.time
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 80
    }
}