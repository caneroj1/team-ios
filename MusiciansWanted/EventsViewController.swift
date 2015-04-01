//
//  EventsViewController.swift
//  MusiciansWanted
//
//  Created by hankharvey on 3/31/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableEvents: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        tableEvents.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Sample data
        
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
        cell.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        return cell
    }
    
    
}