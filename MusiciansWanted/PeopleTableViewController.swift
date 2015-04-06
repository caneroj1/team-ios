//
//  PeopleTableViewController.swift
//  MusiciansWanted
//
//  Created by Nick on 3/27/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        /* some how make update every time view loads
        DataManager.makeGetRequest("/api/users", completion: { (data, error) -> Void in
            let json = JSON(data: data!)
            
            for user in json {
                
                //write if statement that filters setting based on age, looking to jam, and band
                
                pplMgr.addPerson(user.1["name"].stringValue, pic: "anonymous", age: user.1["age"].stringValue, genre: "Unknown", instru: "Unknown", loc: user.1["location"].stringValue)
            }
        })*/
        
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
        
        let person = pplMgr.person[indexPath.row]
        
        cell.lblProfileName.text = person.profname
        cell.imgProfilePic.image = person.profpic
        cell.lblLocation.text = person.location
        cell.lblAge.text = person.age
        cell.lblInstrument.text = person.instrument
        cell.lblGenre.text = person.genre
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 80
    }
}