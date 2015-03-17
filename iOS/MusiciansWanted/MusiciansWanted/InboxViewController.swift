//
//  InboxViewController.swift
//  MusiciansWanted
//
//  Created by Nick on 3/7/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class InboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblInbox: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        tblInbox.reloadData()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tblInbox.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return inboxMgr.messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "txt")
        
        cell.textLabel?.text = inboxMgr.messages[indexPath.row].name
        cell.detailTextLabel?.text = inboxMgr.messages[indexPath.row].subject
        
        
        return cell
    }

    
}