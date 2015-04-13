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
    var notificationArray = [Notification]()
    var feedDelegate: FeedViewDelegate?
    
    func rows() -> Int {
        return notificationArray.count
    }
    
    func getNotification(index: Int) -> Notification {
        return notificationArray[index]
    }
    
    func formatDate(date: String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
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
    
                var id = notificationData["id"].stringValue.toInt()!
            
                var title = notificationData["title"].stringValue
                var location = notificationData["location"].stringValue
                var distanceString = notificationData["distance"].stringValue
                var date = notificationData["created_at"].stringValue
                var type = notificationData["notification_type"].stringValue.toInt()!
                var recordId = 1//notificationData["record_id"].stringValue.toInt()!
                
                var image = ""
                switch type {
                case 0:
                    image = "icon_calendar_small.png"
                case 1:
                    image = "icon_anonymous_small.png"
                default:
                    image = "icon_calendar_small.png"
                }
                
                var newNotification = Notification(title: title, date: self.formatDate(date), location: location, distance: distanceString, imageString: image, recordId: recordId)

                self.notificationArray.append(newNotification)
                self.feedDelegate!.addedNewItem(newNotification)
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