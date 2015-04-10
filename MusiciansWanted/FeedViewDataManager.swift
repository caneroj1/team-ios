//
//  FeedViewDataManager.swift
//  MW
//
//  Created by Joseph Canero on 4/9/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import Foundation

class FeedViewDataManager: NSData {
    // dictionary of notifications indexed by ID.
    // the id will be used to keep track of which notifications have been already added.
    var notificationDictionary = Dictionary<Int, Notification>()
    
    func rows() -> Int {
        return notificationDictionary.count
    }
    
    func formatDate(date: String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd\'T\'HH:mmZ"
        let newDateObject = formatter.dateFromString(date)!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        return dateFormatter.stringFromDate(newDateObject)
    }
    
    func getNotifications(user_id: Int) {
        let url = "/api/notifications?id=\(user_id)"
        DataManager.makeGetRequest(url, completion: { (data, error) -> Void in
            let data = JSON(data: data!)
            for notification in data {
                let notificationData = notification.1
                println(notificationData)
//                let id = notification.0.toInt()!
                
            }
        })
    }
}


// example of sorting by date

/* @objc(Note)
class Note: NSManagedObject {

@NSManaged var content:   String
@NSManaged var date: NSDate
@NSManaged var business: Business
@NSManaged var coldcall: ColdCall
@NSManaged var contact: Contact
}

let notes : [Note] = //array of notes

// sort a collection of notes by date

notes.sort({$0.date.timeIntervalSinceNow > $1.date.timeIntervalSinceNow}) */