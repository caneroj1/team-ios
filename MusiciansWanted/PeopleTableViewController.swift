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
    
    override func viewWillAppear(animated: Bool) {
        pplMgr.loadPeople(0, upper: ttlPpl)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        var newLoc = person?.location.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        var tmpArray1 : [String] = newLoc!.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: ","))
        
        if tmpArray1.count > 2 {
            newLoc = tmpArray1[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) + ", " + tmpArray1[2].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
            var tmpArray2 : [String] = newLoc!.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: "0123456789"))
            
            if tmpArray2.count > 0 {
                newLoc = tmpArray2[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            }
        
        }
        
        cell.lblLocation.text = newLoc
        
        
        /* ------------------- NOTES --------------------
        
        //contains
        var myString = "Swift is really easy!"
        if myString.rangeOfString("easy") != nil {
            println("Exists!")
        }
        
        //substring 1
        let str = "Hello, darling."
        str.substringFromIndex(advance(str.startIndex,7))
        //This jumps over the first 7 characters of the string and grabs the rest,
        //which returns "darling"
        
        //substring 2
        let str2 = "Hello, darling."
        str2.substringToIndex(advance(str2.startIndex, 5))
        //This grabs the first 5 characters of the string and stops there,
        //which returns "Hello"
        
        //Replace
        let myString2 = "Here is the string 231 success"
        let myReplacementString = String(map(myString2.generate()) {
            $0 == "#" ? "," : $0
            })
        println(myReplacementString) //Outputs "Here-is-the-string" to the console.
        
        //Split string
        var myString3 = "4th St, New York, New York 10053"
        var array : [String] = myString3.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: ",0123456789"))
        for yolo in array {
            println(yolo)
        }
        //Returns ["One", "Two", "Three", "1", "2", "3"]
        
        ------------------- NOTES -------------------- */
        
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
        cell.lblGenre.text = person?.genre
        
        /*
        let mobileAnalytics = AWSMobileAnalytics(forAppId: MobileAnalyticsAppId)
        let eventRecordClient = mobileAnalytics.eventClient
        let eventRecord = eventRecordClient.createEventWithEventType("PeopleViewEvent")
        
        eventRecord.addAttribute("Hank", forKey: "People")
        
        eventRecordClient.recordEvent(eventRecord)*/
        
        // Save the indexPath of the user
        pplMgr.person[pplMgr.arrPerson[indexPath.row]]?.indexPth = indexPath
        
        return cell
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        var currentOffset = scrollView.contentOffset.y;
        var maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= 2.0 && pplMgr.isLoadingPeople == false) {
            pplMgr.isLoadingPeople = true
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
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let person = pplMgr.person[pplMgr.arrPerson[indexPath.row]]
        
        let personView = self.storyboard?.instantiateViewControllerWithIdentifier("PersonViewController") as! PersonViewController
        
        personView.controller = "people"
        personView.icon = person?.profpic
        personView.id = person?.id
        
        self.navigationController?.pushViewController(personView, animated: true)
    }
}