//
//  InboxTableViewController.swift
//  MW
//
//  Created by Nick on 4/3/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class InboxTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageDelegate {
    
    @IBOutlet var receivedSent: UISegmentedControl!
    @IBOutlet var inboxTable: UITableView!
    
    var inboxMgr: InboxManager = InboxManager()
    
    
    @IBAction func selectReceivedSent(sender: AnyObject) {
        inboxTable.reloadData()
        
        if receivedSent.selectedSegmentIndex == 0 {
            inboxMgr.loadInbox()
        }
        else {
            inboxMgr.loadSent()
        }
    }
    
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
        inboxMgr.loadSent()
        inboxTable.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        inboxTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if receivedSent.selectedSegmentIndex == 0 {
            return inboxMgr.messages.count
        }
        else {
            return inboxMgr.sent_messages.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Msg", forIndexPath: indexPath) as! InboxCell
                
        var message: inbox
        
        if receivedSent.selectedSegmentIndex == 0 {
            message = inboxMgr.messageDictionary[inboxMgr.messages[indexPath.row]]!
        }
        else {
            message = inboxMgr.sent_messageDictionary[inboxMgr.sent_messages[indexPath.row]]!
        }
       
        cell.lblProfName.text = message.name
        cell.lblSubject.text = message.subject == "" ? "No Subject" : message.subject
        cell.imgProfPic.image = message.profpic
        cell.lblDate.text = inboxMgr.formatDate(message.date)
        
        cell.lblSubject.numberOfLines = 1
        cell.lblBody.text = message.body
        
        if message.read == false {
            cell.bgView.hidden = false
        }
        else {
            cell.bgView.hidden = true
        }
        
        if receivedSent.selectedSegmentIndex == 0 {
            inboxMgr.messageDictionary[inboxMgr.messages[indexPath.row]]?.cellHeight = 85
        }
        else {
            inboxMgr.sent_messageDictionary[inboxMgr.sent_messages[indexPath.row]]?.cellHeight = 85
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if receivedSent.selectedSegmentIndex == 0 {
            return inboxMgr.messageDictionary[inboxMgr.messages[indexPath.row]]!.cellHeight
        }
        else {
            return 85
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let messageView = self.storyboard?.instantiateViewControllerWithIdentifier("RepliesView") as! MessagesViewController
        
        var messageParams: Dictionary<String, AnyObject>
        
        if receivedSent.selectedSegmentIndex == 0 {
            messageView.messageId = inboxMgr.messageDictionary[inboxMgr.messages[indexPath.row]]!.id
            inboxMgr.messageDictionary[inboxMgr.messages[indexPath.row]]!.read = true
            messageView.subject = inboxMgr.messageDictionary[inboxMgr.messages[indexPath.row]]!.subject
            messageView.receiverId = inboxMgr.messageDictionary[inboxMgr.messages[indexPath.row]]!.receiverId
            
            messageParams = ["seen_by_receiver": true]
        }
        else {
            messageView.messageId = inboxMgr.sent_messageDictionary[inboxMgr.sent_messages[indexPath.row]]!.id
            inboxMgr.sent_messageDictionary[inboxMgr.sent_messages[indexPath.row]]!.read = true
            messageView.subject = inboxMgr.sent_messageDictionary[inboxMgr.sent_messages[indexPath.row]]!.subject
            messageView.receiverId = inboxMgr.sent_messageDictionary[inboxMgr.sent_messages[indexPath.row]]!.receiverId
            
            messageParams = ["seen_by_sender": true]
        }
        
        let mUrl = "/api/messages/\(messageView.messageId)"
        
        var mparams = ["message": messageParams]
        
        DataManager.makePatchRequest(mUrl, params: mparams, completion: { (data, error) -> Void in
            var json = JSON(data: data!)
            var errorString = DataManager.checkForErrors(json)
            if errorString != "" {
                dispatch_async(dispatch_get_main_queue()) {
                    SweetAlert().showAlert("Oops!", subTitle: errorString, style: AlertStyle.Error)
                    return
                }
            }
        })
        
        self.navigationController?.pushViewController(messageView, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //Delete Message
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            if receivedSent.selectedSegmentIndex == 0 {
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
                            
                            self.inboxTable.reloadData()
                            
                            return
                        }
                    }
                })
            }
            else {
                var url = "/api/messages/\(inboxMgr.sent_messages[indexPath.row])"
                
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
                            
                            self.inboxMgr.sent_messageDictionary.removeValueForKey(self.inboxMgr.sent_messages[indexPath.row])
                            self.inboxMgr.sent_messages.removeAtIndex(indexPath.row)
                            
                            self.inboxTable.reloadData()
                            
                            return
                        }
                    }
                })
                
            }
            
        }
        
    }
    
    func addedNewMessage() {
        inboxTable.reloadData()
    }
}