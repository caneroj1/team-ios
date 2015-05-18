//
//  EventManager.swift
//  MW
//
//  Created by hankharvey on 4/7/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit
import MapKit

struct events {
    var eventId = 0
    var eventName = "Un-named"
    var eventPicture = UIImage(named: "default")
    var hasEventPic = "false"
    var eventDate = "None"
    var eventGenre = "None"
    var eventLocation = "Unknown"
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
}

class EventsManager: NSObject {
    var isNearMeURL = false
    var eventDelegate: EventsDelegate?
    var event = [Int]()
    var eventDictionary = [Int: events]()
    var isLoadingEvents = false
    
    func loadEvents(lower: Int, upper: Int) {
        var url: String
        
        eventDictionary = [Int: events]()
        
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedWhenInUse:
            url = "/api/users/\(MusiciansWanted.userId)/events_near_me"
            isNearMeURL = true
        case .Restricted, .Denied, .AuthorizedAlways, .NotDetermined:
            url = "/api/events"
            isNearMeURL = false
        }
        
        DataManager.makeGetRequest(url, completion: { (data, error) -> Void in
            let json = JSON(data: data!)
            
            self.isLoadingEvents = true
            
            //for event in json {
            for index in lower...upper {
                
                if index >= json.count {
                    //println("loop broken.");
                    break;
                }
                var eventData = json[index]
                var id = eventData["id"].intValue;
                var title = eventData["title"].stringValue
                var tempPic = eventData["has_event_pic"];
                var hasPicString = tempPic.stringValue
                
                
                var eventImage = UIImage(named: "default")!
                
                var longitude = eventData["longitude"].stringValue
                var latitude = eventData["latitude"].stringValue
                
                let longStr: NSString = NSString(string: longitude)
                let latStr: NSString = NSString(string: latitude)
                

                println("\(id) : \(title)")
                
                self.eventDictionary[id] = events(eventId: eventData["id"].intValue, eventName: eventData["title"].stringValue, eventPicture: eventImage, hasEventPic: hasPicString, eventDate: eventData["event_time"].stringValue, eventGenre: "id: " + eventData["id"].stringValue, eventLocation: eventData["location"].stringValue, latitude: latStr.doubleValue, longitude: longStr.doubleValue)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.eventDelegate?.addedNewEvent()
                self.event = Array(self.eventDictionary.keys).sorted(<)

                //println("Event Data Loaded.")
                
            }
        })
    }
}
