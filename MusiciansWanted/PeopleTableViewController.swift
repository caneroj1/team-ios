//
//  PeopleTableViewController.swift
//  MusiciansWanted
//
//  Created by Nick on 3/27/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController, UITableViewDataSource, PeopleDelegate {

    var ttlPpl = 24
    var pplMgr = PeopleManager()
    var refreshToken = ""
    
    override func viewWillAppear(animated: Bool) {
        pplMgr.loadPeople(0, upper: ttlPpl)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Loading More People")
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl?.layer.zPosition = -1
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        pplMgr.peopleDelegate = self
        //pplMgr.getNotifications(MusiciansWanted.userId)
        //pplMgr.loadPeople(pplMgr.arrPerson.count, upper: ttlPpl)
        
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PeopleCell
        
        //Display the user information in the cell
        let person = pplMgr.person[pplMgr.arrPerson[indexPath.row]];
        
        cell.lblProfileName.text = person?.profname
        cell.imgProfilePic.image = person?.profpic
        
        //Format and display the location
        var newLoc = person?.location.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        var tmpArray1 : [String] = newLoc!.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: "\n:"))
        
        if tmpArray1.count > 2 {
            newLoc = tmpArray1[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        }
        
        var dist = "\(person!.distance)"
        dist = dist.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if person?.distance < 0 || person?.distance == nil || count(dist) < 3 {
            dist = ""
        }
        else
        {
            if person!.distance >= 10 && count(dist) >= 4
            {
                dist = dist.substringToIndex(advance(dist.startIndex, 4)) + " mi - "
            }
            else
            {
                dist = dist.substringToIndex(advance(dist.startIndex, 3)) + " mi - "

            }
        }
        
        
        if newLoc == "" || newLoc == nil {
            cell.lblLocation.text = "Location Disabled"
        }
        else {
            cell.lblLocation.text = dist + newLoc!

        }
    
        
        if person?.gender == "male" {
            cell.lblAge.text = "Male, \(person!.age)"
        }
        else if person?.gender == "female" {
            cell.lblAge.text = "Female, \(person!.age)"
        }
        else {
            cell.lblAge.text = person?.age
        }

        cell.lblInstrument.text = person?.instrument
        
        //Format genre
        let aString: String = dropLast((person!.genre).isEmpty ? ":" : person!.genre)
        let newString = aString.stringByReplacingOccurrencesOfString(":", withString: ", ")
        
        println(newString)

        cell.lblGenre.text = aString.isEmpty ? "Unknown" : newString
        
        let mobileAnalytics = AWSMobileAnalytics(forAppId: MobileAnalyticsAppId)
        let eventRecordClient = mobileAnalytics.eventClient
        let eventRecord = eventRecordClient.createEventWithEventType("PeopleViewEvent")
        
        eventRecord.addAttribute("Hank", forKey: "People")
        
        eventRecordClient.recordEvent(eventRecord)
        
        // Save the indexPath of the user
        pplMgr.person[pplMgr.arrPerson[indexPath.row]]?.indexPth = indexPath
        
        return cell
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        var currentOffset = scrollView.contentOffset.y;
        var maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= 2.0 && pplMgr.isLoadingPeople == false) {
            pplMgr.isLoadingPeople = true
            println("expanding size")
            ttlPpl = pplMgr.arrPerson.count + 10;
            
            
            pplMgr.loadPeople(pplMgr.arrPerson.count, upper: ttlPpl)
            
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 80
    }
    
    func addedNewItem() {
        if self.refreshControl?.refreshing == true {
            self.refreshControl?.endRefreshing()
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let person = pplMgr.person[pplMgr.arrPerson[indexPath.row]]
        
        let personView = self.storyboard?.instantiateViewControllerWithIdentifier("PersonViewController") as! PersonViewController
        
        personView.controller = "people"
        personView.icon = person?.profpic
        personView.id = person?.id
        
        self.navigationController?.pushViewController(personView, animated: true)
    }
    
    func stopRefreshing() {
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: Refresh Control
    func refresh(sender: AnyObject) {
        ttlPpl = pplMgr.arrPerson.count + 10;
        pplMgr.loadPeople(pplMgr.arrPerson.count, upper: ttlPpl)
    }
}