//
//  EventsInterfaceController.swift
//  MW
//
//  Created by Joseph Canero on 5/19/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import WatchKit
import Foundation


class EventsInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var eventsTable: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        let userDictionary: [String: String] = ["find": "events"]
        setLoadingStatus()
        getEvents(userDictionary)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func getEvents(userDictionary: [String: String]) {
        WKInterfaceController.openParentApplication(userDictionary, reply: { (reply, error) -> Void in
            if let message = error {
                println(message)
                return
            }
            
            if let events = reply["results"] as? [String] {
                self.eventsTable.setNumberOfRows(events.count, withRowType: "EventRow")
                for (index, event) in enumerate(events) {
                    var eventInfo = event.componentsSeparatedByString(",")
                    if let rowController = self.eventsTable.rowControllerAtIndex(index) as? EventRow {
                        rowController.eventTitle.setText(eventInfo[0])
                        rowController.eventTitle.setTextColor(UIColor(red: 255.0/255.0, green: 90.0/255.0, blue: 0.0/255.0, alpha: 1.0))
                        rowController.eventDate.setText(self.formatDateForWatch(eventInfo[1]))
                        rowController.eventLocation.setText(eventInfo[2])
                    }
                    println(event)
                }
            }
            else {
                let error = reply["error"] as? String
                self.eventsTable.setNumberOfRows(1, withRowType: "EventRow")
                if let rowController = self.eventsTable.rowControllerAtIndex(0) as? EventRow {
                    rowController.eventTitle.setText(error)
                    rowController.eventDate.setText("")
                    rowController.eventLocation.setText("")
                }
            }
        })
    }
    
    func formatDateForWatch(date: String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        
        let outputter = NSDateFormatter()
        outputter.dateStyle = NSDateFormatterStyle.ShortStyle
        outputter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let offset = Double(formatter.timeZone.secondsFromGMT)
        let newDateObject = formatter.dateFromString(date)?.dateByAddingTimeInterval(offset)
        return outputter.stringFromDate(newDateObject!)
    }
    
    func setLoadingStatus() {
        eventsTable.setNumberOfRows(1, withRowType: "EventRow")
        if let rowController = eventsTable.rowControllerAtIndex(0) as? EventRow {
            rowController.eventTitle.setText("Loading Events")
            rowController.eventDate.setText("")
            rowController.eventLocation.setText("")
        }
    }
}
