//
//  MusicianRequestTableViewController.swift
//  MW
//
//  Created by Joseph Canero on 5/17/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class MusicianRequestTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var instrumentPickerView: UIPickerView!
    var instruments = ["Drummer", "Guitarist", "Bassist", "Vocalist", "Pianist", "Keyboardist", "Percussionist"]
    var selectedInstrument = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        instrumentPickerView.selectRow(0, inComponent: 0, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitMusicianRequest(sender: AnyObject) {
        let musicianRequestParams: Dictionary<String, AnyObject> = ["instrument": instruments[selectedInstrument] ]
        let params: Dictionary<String, AnyObject> = ["user_id": MusiciansWanted.userId, "musician_request": musicianRequestParams]
        
        let postUrl = "/api/users/\(MusiciansWanted.userId)/musician_requests"
        
        DataManager.makePostRequest(postUrl, params: params, completion: { (data, error) -> Void in
            var json = JSON(data: data!)
            var errorString = DataManager.checkForErrors(json)
            if errorString != "" {
                dispatch_async(dispatch_get_main_queue()) {
                    SweetAlert().showAlert("Oops!", subTitle: errorString, style: AlertStyle.Error)
                    return
                }
            }
            else {
                dispatch_async(dispatch_get_main_queue()) {
                    SweetAlert().showAlert("Success!", subTitle: "You have created a new musician request!", style: AlertStyle.Success)
                    return
                }
            }
        })
    }
    
    // MARK: - Picker view delegate methods
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        println("count \(instruments.count)")
        return instruments.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedInstrument = row
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.blackColor()
        pickerLabel.text = instruments[row]
        pickerLabel.font = UIFont(name: "MarkerFelt", size: 24)
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }
    
    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 0
//    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
