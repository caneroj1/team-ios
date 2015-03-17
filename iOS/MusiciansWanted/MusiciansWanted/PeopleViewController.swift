//
//  PeopleViewController.swift
//  MusiciansWanted
//
//  Created by Nick on 3/7/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Register custom cell
        var nib = UINib(nibName: "PeopleCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 0 //when this is greater than 0 it throws a runtime error
    }
    
    //* Will probablt need to be rewritten
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        var cell: PeopleViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as PeopleViewCell
        
        cell.imgProfilePic.image = UIImage(named: "people.png")
        cell.lblProfileName.text = "Marco Polo"
        //cell.lblCarName.text = tableData[indexPath.row]
        //cell.imgCarName.image = UIImage(named: tableData[indexPath.row])
        
        return cell
    }

    
}