//
//  FeedSettingsTableViewController.swift
//  MW
//
//  Created by Joseph Canero on 5/28/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class FeedSettingsTableViewController: UITableViewController, UIPickerViewDelegate {

    var feedDataManager: FeedViewDataManager?
    var sortBy = ["Everyone","My Contacts","Only Me"]
    var selectedSort = NSUserDefaults.standardUserDefaults().objectForKey("selectedSort") == nil ? 1 : NSUserDefaults.standardUserDefaults().integerForKey("selectedSort")
   
    @IBOutlet weak var sortPicker: UIPickerView!
    @IBOutlet weak var myNotificationsSwitch: UISwitch!
    @IBOutlet weak var contactsNotificationsSwitch: UISwitch!
    @IBOutlet weak var eventsNotificationsSwitch: UISwitch!
    @IBOutlet weak var usersNotificationsSwitch: UISwitch!
    @IBOutlet weak var musicianRequestsNotificationsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        myNotificationsSwitch.on = FeedFilters.hideMyNotifications
        contactsNotificationsSwitch.on = FeedFilters.hideContactNotifications
        eventsNotificationsSwitch.on = FeedFilters.hideEventNotifications
        usersNotificationsSwitch.on = FeedFilters.hideUserNotifications
        musicianRequestsNotificationsSwitch.on = FeedFilters.hideMusicianRequestNotification
        sortPicker.selectRow(selectedSort, inComponent: 0, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 { return 2 }
        else            { return 3 }
    }*/

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if let destinationVC = segue.destinationViewController as? FeedTableViewController {
            println("going to table")
            destinationVC.tableViewDataSource.applyFilters()
        }
    }
    
    // MARK: - Storyboard Actions
    
    @IBAction func hideMyNotifications(sender: UISwitch) {
        FeedFilters.hideMyNotifications = sender.on
        feedDataManager?.applyFilters()
    }

    @IBAction func hideContactNotifications(sender: UISwitch) {
        FeedFilters.hideContactNotifications = sender.on
        feedDataManager?.applyFilters()
    }
    
    @IBAction func hideEventNotifications(sender: UISwitch) {
        FeedFilters.hideEventNotifications = sender.on
        feedDataManager?.applyFilters()
    }
    
    @IBAction func hidePeopleNotifications(sender: UISwitch) {
        FeedFilters.hideUserNotifications = sender.on
        feedDataManager?.applyFilters()
    }
    
    @IBAction func hideMusicianRequestNotifications(sender: UISwitch) {
        FeedFilters.hideMusicianRequestNotification = sender.on
        feedDataManager?.applyFilters()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return sortBy.count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView{
        
        var pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.blackColor()
        pickerLabel.text = sortBy[row]
        // pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
        pickerLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 20)
        pickerLabel.textAlignment = NSTextAlignment.Center
        
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        selectedSort = row
        NSUserDefaults.standardUserDefaults().setObject(selectedSort, forKey: "selectedSort")
    }
}
