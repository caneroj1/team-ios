//
//  FeedViewDataManager.swift
//  MW
//
//  Created by Joseph Canero on 4/9/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import Foundation

struct FeedFilters {
    static var hideMyNotifications: Bool = false
    static var hideContactNotifications: Bool = false
    static var hideUserNotifications: Bool = false
    static var hideEventNotifications: Bool = false
    static var hideMusicianRequestNotification: Bool = false
}

class FeedViewDataManager: NSData {
    // dictionary of notifications indexed by ID.
    // the id will be used to keep track of which notifications have been already dded.
    var notificationArray = [Notification]()
    var notificationDict = [Int: Bool]()
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
        
        let outputter = NSDateFormatter()
        outputter.dateStyle = NSDateFormatterStyle.ShortStyle
        outputter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let offset = Double(formatter.timeZone.secondsFromGMT)
        let newDateObject = formatter.dateFromString(date)?.dateByAddingTimeInterval(offset)
        return outputter.stringFromDate(newDateObject!)
    }
    
    func refreshNotifications(user_id: Int) {
        let url = "/api/notifications?id=\(user_id)"
        DataManager.makeGetRequest(url, completion: { (data, error) -> Void in
            let data = JSON(data: data!)
            var newNotifications = [Notification]()
            for notification in data {
                let notificationData = notification.1
                
                var id = notificationData["id"].stringValue.toInt()!
                if (self.notificationDict.indexForKey(id) == nil) {
                    var title = notificationData["title"].stringValue
                    var location = notificationData["location"].stringValue
                    var distanceString = notificationData["distance"].stringValue
                    var date = notificationData["created_at"].stringValue
                    var type = notificationData["notification_type"].stringValue.toInt()!
                    var recordId = notificationData["record_id"].stringValue.toInt()!
                    
                    var image = ""
                    switch type {
                    case 0:
                        image = "icon_calendar_small.png"
                    case 1:
                        image = "icon_anonymous_small.png"
                    case 2:
                        image = "music_note.png"
                    default:
                        image = "icon_calendar_small.png"
                    }
                    
                    var newNotification = Notification(title: title, date: self.formatDate(date), location: location, distance: distanceString, imageString: image, recordId: recordId, notificationType: type, id: id)
                    
                    if self.notificationPasses(newNotification) {
                        self.notificationDict.updateValue(true, forKey: id)
                        newNotifications.append(newNotification)
                    }
                }
            }
            
            if !newNotifications.isEmpty {
                self.notificationArray = newNotifications + self.notificationArray
                self.feedDelegate?.addedNewItem()
            }
            else {
                self.feedDelegate?.stopRefreshing()
            }
        })
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
                var recordId = notificationData["record_id"].stringValue.toInt()!
                
                var image = ""
                switch type {
                case 0:
                    image = "icon_calendar_small.png"
                case 1:
                    image = "icon_anonymous_small.png"
                case 2:
                    image = "music_note.png"
                default:
                    image = "icon_calendar_small.png"
                }
                
                var newNotification = Notification(title: title, date: self.formatDate(date), location: location, distance: distanceString, imageString: image, recordId: recordId, notificationType: type, id: id)
                
                if self.notificationPasses(newNotification) {
                    self.notificationDict.updateValue(true, forKey: id)
                    self.notificationArray.append(newNotification)
                    self.feedDelegate!.addedNewItem()
                }
            }
        })
    }
    
    func applyFilters() {
        filterNotifications()
        self.feedDelegate?.appliedFilters()
    }
    
     func filterNotifications() {
        var tmpArray = [Notification]()
        
        for (index, notification) in enumerate(notificationArray) {
            // filter out notifications
            if !notificationPasses(notification) {
                notificationDict.removeValueForKey(notification.id)
            }
            else {
                tmpArray.append(notification)
            }
        }
        notificationArray = tmpArray
    }
    
    // 0 = event
    // 1 = user
    // 2 = request
    func notificationPasses(notification: Notification) -> Bool {
        var pass = true
        
        // hide item types
        switch notification.notificationType {
        case 0:
            pass = pass && !FeedFilters.hideEventNotifications
        case 1:
            pass = pass && !FeedFilters.hideUserNotifications
        case 2:
            pass = pass && !FeedFilters.hideMusicianRequestNotification
        default:
            pass = false // if we get in here, it's a problem
        }
        
        // hide notifications from contacts
        if FeedFilters.hideContactNotifications && notification.notificationType == 1 {
            pass = pass && !notificationIsFromContacts(notification.recordId)
        }
        
        // hide notifications that are from me
        // TO BE IMPLEMENTED
        return pass
    }
    
    func notificationIsFromContacts(id: Int) -> Bool {
        return MusiciansWanted.contacts?.findKey(id) != nil
    }
}