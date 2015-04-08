//
//  PeopleTableViewController.swift
//  MusiciansWanted
//
//  Created by Nick on 3/27/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController {

    var expandingView = false;
    var ttlPpl = 99;
    var sortedArr = Array(pplMgr.person.keys).sorted(<)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        pplMgr.loadPeople(0,upper: ttlPpl);
        sortedArr = Array(pplMgr.person.keys).sorted(<)
        
        for key in sortedArr {
            println(pplMgr.person[key])
        }
        
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return pplMgr.person.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as PeopleCell
        
        let person = pplMgr.person[sortedArr[indexPath.row]];
        
        cell.lblProfileName.text = person?.profname
        cell.imgProfilePic.image = person?.profpic
        cell.lblLocation.text = person?.location
        cell.lblAge.text = person?.age
        cell.lblInstrument.text = person?.instrument
        cell.lblGenre.text = person?.genre

        
        /*
        // Sample Data
        cell.lblProfileName.text = "Rob"
        cell.imgProfilePic.image = UIImage(named: "Ultra Lord")
        cell.lblLocation.text = "Trenton, NJ"
        cell.lblAge.text = "8"
        cell.lblInstrument.text = "Trumpet"
        cell.lblGenre.text = "Trance"
        */
        
        return cell
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        var currentOffset = scrollView.contentOffset.y;
        var maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= 20.0 && expandingView == false) {
            println("expanding size");
            expandingView = true
            ttlPpl = pplMgr.person.count + 100;
            
            pplMgr.loadPeople(pplMgr.person.count, upper: ttlPpl)
       
        }
        else if (pplMgr.person.count >= ttlPpl) {
            expandingView = false;
            tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 80
    }
}