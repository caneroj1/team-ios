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
    var event = [events]()
    var eventDictionary = [Int: Bool]()
    var isLoadingEvents = false
    
    func addEvents(tempId: Int, name: String, picture: UIImage, hasPic: String, date: String, genre: String, location: String, latitude: Double, longitude: Double){
        
        if event.count >= tempId {
            event[tempId-1].eventName = name;
            event[tempId-1].eventPicture = picture;
            event[tempId-1].hasEventPic = hasPic;
            event[tempId-1].eventDate = date;
            event[tempId-1].eventGenre = genre;
            event[tempId-1].eventLocation = location;
        }
        else {
            eventDictionary.updateValue(true, forKey: tempId)
            var tmpArray = [events(eventId: tempId, eventName: name, eventPicture: picture, hasEventPic: hasPic, eventDate: date, eventGenre: genre, eventLocation: location, latitude: latitude, longitude: longitude)]
            
            event = tmpArray + event

        }
        
        self.eventDelegate!.addedNewEvent()

    }
    
    func loadEvents(lower: Int, upper: Int) {
        var url: String
        
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
                
                //write if statement that filters setting based on age, looking to jam, and band
                //Add basic information of events
                
                
                var eventImage = UIImage(named: "default")!
                
                
                //var eventImage = UIImage(named: "default")!
                
                var longitude = eventData["longitude"].stringValue
                var latitude = eventData["latitude"].stringValue
                
                let longStr: NSString = NSString(string: longitude)
                let latStr: NSString = NSString(string: latitude)
                

                //println("\(id) : \(title)")
                if self.eventDictionary.indexForKey(eventData["id"].intValue) == nil {
                    self.addEvents(eventData["id"].intValue, name: eventData["title"].stringValue, picture: eventImage, hasPic: hasPicString, date: eventData["event_time"].stringValue, genre: "id: " + eventData["id"].stringValue, location: eventData["location"].stringValue, latitude: latStr.doubleValue, longitude: longStr.doubleValue)
                    
                    //println("Adding event \(id)")
                }
                else {
                    //println("Did not add event")
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.eventDelegate?.addedNewEvent()
//                self.event = Array(self.eventDictionary.keys).sorted(<)

                //println("Event Data Loaded.")
                
            }
        })
    }
}
