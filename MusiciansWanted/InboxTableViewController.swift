//
//  InboxTableViewController.swift
//  MW
//
//  Created by Nick on 4/3/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class InboxTableViewController: UITableViewController, MessageDelegate {
    
    var inboxMgr: InboxManager = InboxManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        /*
        let mobileAnalytics = AWSMobileAnalytics(forAppId: MobileAnalyticsAppId)
        let eventRecordClient = mobileAnalytics.eventClient
        let eventRecord = eventRecordClient.createEventWithEventType("InboxViewEvent")
        
        eventRecord.addAttribute("Test", forKey: "Inbox")
        
        eventRecordClient.recordEvent(eventRecord)
        eventRecordClient.submitEvents()*/
        
        inboxMgr.messageDelegate = self
        inboxMgr.loadInbox()
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
        return inboxMgr.messages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Msg", forIndexPath: indexPath) as! InboxCell
        
        let message = inboxMgr.messageDictionary[inboxMgr.messages[indexPath.row]]
       
        cell.lblProfName.text = message!.name
        cell.lblSubject.text = message!.subject == "" ? "No Subject" : message!.subject
        cell.imgProfPic.image = message?.profpic
        cell.lblDate.text = formatDate(message!.date)
        
        var cellcolor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        
        /* if message?.isExpanded == true {
            cell.lblBody.text = ""
            cell.lblFullBody.text = message?.body
            cell.lblFullBody.hidden = false
            cell.lblSubject.numberOfLines = 0
            
            let textViewFixedWidth = self.view.frame.size.width
            let newSize = cell.lblFullBody.sizeThatFits(CGSizeMake(textViewFixedWidth, CGFloat(MAXFLOAT)))
            
            inboxMgr.messageDictionary[inboxMgr.messages[indexPath.row]]?.cellHeight = newSize.height + 150
            
            cell.lblFullBody.sizeToFit()
        }
        else { */
            cell.lblSubject.numberOfLines = 1
            cell.lblBody.text = message!.body
            inboxMgr.messageDictionary[inboxMgr.messages[indexPath.row]]?.cellHeight = 85
            cell.lblFullBody.text = ""
            cell.lblFullBody.hidden = true
        //}
        cell.bgView.backgroundColor = cellcolor

        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return inboxMgr.messageDictionary[inboxMgr.messages[indexPath.row]]!.cellHeight
    }
    
    /*override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        let message = inboxMgr.messageDictionary[inboxMgr.messages[indexPath.row]]
        
        if message?.isExpanded == true {
            inboxMgr.messageDictionary[inboxMgr.messages[indexPath.row]]?.isExpanded = false
        }
        else {
            inboxMgr.messageDictionary[inboxMgr.messages[indexPath.row]]?.isExpanded = true
        }
        
        tableView.reloadData()
    }*/
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //Delete Message
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            var url = "/api/messages/\(inboxMgr.messages[indexPath.row])"
            
            DataManager.makeDestroyRequest(url, completion: { (data, error) -> Void in
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
                        SweetAlert().showAlert("Success!", subTitle: "Message deleted.", style: AlertStyle.Success)
                        
                    self.inboxMgr.messageDictionary.removeValueForKey(self.inboxMgr.messages[indexPath.row])
                    self.inboxMgr.messages.removeAtIndex(indexPath.row)
                    
                    self.tableView.reloadData()
                        
                    return
                    }
                }
            })
            
        }
        
    }
    
    //There's definitely a much more efficient way of doing this
    func formatDate(strDate: String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        
        let offset = Double(formatter.timeZone.secondsFromGMT)
        let date = (formatter.dateFromString(strDate))!.dateByAddingTimeInterval(offset)
        
        let currentdate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        
        //Get current date information
        let currentcomponent = calendar.components(.CalendarUnitDay | .CalendarUnitYear | .CalendarUnitMonth, fromDate: currentdate)
        let currentday = currentcomponent.day
        let currentyear = currentcomponent.year
        let currentmonth = currentcomponent.month
        
        //Get message date information
        let messagecomponent = calendar.components(.CalendarUnitDay | .CalendarUnitYear | .CalendarUnitMonth, fromDate: date)
        let messageday = messagecomponent.day
        let messageyear = messagecomponent.year
        let messagemonth = messagecomponent.month
        
        let outputter = NSDateFormatter()

        //Determine how to format
        if currentyear == messageyear && currentmonth == messagemonth {
            if currentday == messageday {
                outputter.timeStyle = NSDateFormatterStyle.ShortStyle
                outputter.dateStyle = NSDateFormatterStyle.NoStyle

            }
            else if currentday - messageday < 7 {
                outputter.dateFormat = "EEEE"
            }
            else {
                outputter.dateStyle = NSDateFormatterStyle.ShortStyle
                outputter.timeStyle = NSDateFormatterStyle.NoStyle
            }
            
        }
        else {
            outputter.dateStyle = NSDateFormatterStyle.ShortStyle
            outputter.timeStyle = NSDateFormatterStyle.NoStyle
        }

        return outputter.stringFromDate(date)
    }
    
    func addedNewMessage() {
        tableView.reloadData()
    }
}