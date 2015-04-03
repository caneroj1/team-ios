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
        
        pplMgr.addPerson("Ultra Lord", pic: "Ultra Lord", age: "Male, 45", genre: "Rock, Heavy Metal", instru: "Vocals", loc: "Retroville, NJ")
        pplMgr.addPerson("Kari Gilbertson", pic: "people", age: "Female, 22", genre: "Indie, Alternative", instru: "Acoustic Guitar, Electric Guitar, Piano", loc: "Trenton, NJ")
        pplMgr.addPerson("Hank Harvey", pic: "people", age: "Male, 20", genre: "Techno", instru: "Triangle", loc: "South Jersey, NJ")
        pplMgr.addPerson("Peter DePasquale", pic: "people", age: "Male, not a day over 25", genre: "Heavy Metal", instru: "Maracas", loc: "Mahwah, NJ")
        pplMgr.addPerson("Nicholas Amuso", pic: "people", age: "Male, 20", genre: "Electronic, Hip-Hop", instru: "Drums", loc: "Teaneck, NJ")
        pplMgr.addPerson("Marco Polo", pic: "people", age: "Male, 35", genre: "Country", instru: "Violin, Bass, Flute", loc: "Philadelphia, PA")
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
        cell.imgProfilePic.image = UIImage(named: person.profpic)
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