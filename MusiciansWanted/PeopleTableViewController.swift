//
//  PeopleTableViewController.swift
//  MusiciansWanted
//
//  Created by Nick on 3/27/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController, PeopleDelegate {

    var ttlPpl = 24;
    var pplMgr = PeopleManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        pplMgr.peopleDelegate = self
        //pplMgr.getNotifications(MusiciansWanted.userId)
        pplMgr.loadPeople(pplMgr.arrPerson.count, upper: ttlPpl)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return pplMgr.arrPerson.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as PeopleCell
        
        //Display the user information in the cell
        let person = pplMgr.person[pplMgr.arrPerson[indexPath.row]];
        
        cell.lblProfileName.text = person?.profname
        cell.imgProfilePic.image = person?.profpic
        cell.lblLocation.text = person?.location
        cell.lblAge.text = person?.age
        cell.lblInstrument.text = person?.instrument
        cell.lblGenre.text = person?.genre
        
        // Save the indexPath of the user
        pplMgr.person[pplMgr.arrPerson[indexPath.row]]?.indexPth = indexPath
        
        return cell
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        var currentOffset = scrollView.contentOffset.y;
        var maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= 20.0 && pplMgr.isLoadingPeople == false) {
            println("expanding size");
            ttlPpl = pplMgr.arrPerson.count + 10;
            
            pplMgr.loadPeople(pplMgr.arrPerson.count, upper: ttlPpl)
       
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 80
    }
    
    func addedNewItem() {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
}