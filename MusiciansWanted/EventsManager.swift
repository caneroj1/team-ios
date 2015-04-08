//
//  EventManager.swift
//  MW
//
//  Created by hankharvey on 4/7/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

var eventManager: EventsManager = EventsManager()

struct events {
    var eventId = 0
    var eventName = "Un-named"
    var eventPicture = UIImage(named: "default")
    var eventDate = "None"
    var eventGenre = "None"
    var eventLocation = "Unknown"
}

class EventsManager: NSObject {
    
    var event = [events]()
    
    func addEvents(tempId: Int, name: String, picture: UIImage, date: String, genre: String, location: String){
        
        if event.count >= tempId {
            event[tempId-1].eventName = name;
            event[tempId-1].eventPicture = picture;
            event[tempId-1].eventDate = date;
            event[tempId-1].eventGenre = genre;
            event[tempId-1].eventLocation = location;
        }
        else {
            event.append(events(eventId: tempId, eventName: name, eventPicture: picture, eventDate: date, eventGenre: genre, eventLocation: location))
        }
    }
    
    func loadEvents(lower: Int, upper: Int) {
        
        DataManager.makeGetRequest("/api/events", completion: { (data, error) -> Void in
            let json = JSON(data: data!)
            
            //for event in json {
            for index in lower...upper {
                
                if index >= json.count {
                    println("loop broken.");
                    break;
                }
                var eventData = json[index]
                var id = eventData["id"];
                
                //write if statement that filters setting based on age, looking to jam, and band
                //Add basic information of events
                var eventImage = UIImage(named: "default")!
                
                eventManager.addEvents(eventData["id"].intValue, name: eventData["title"].stringValue, picture: eventImage, date: eventData["event_time"].stringValue, genre: "id: " + eventData["id"].stringValue, location: eventData["location"].stringValue)
                
                println("Adding event \(id)");
                
                
                //Load in profile images
                if eventData["has_profile_pic"].stringValue == "true"
                {
                    println("loading profile picture of \(id)");
                    var url = "/api/s3get?event_id=\(id)"
                    DataManager.makeGetRequest(url, completion: { (data, error) -> Void in
                        if data != nil {
                            var json = JSON(data: data!)
                            if json["picture"] != nil {
                                var base64String = json["picture"].stringValue
                                let decodedString = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                                dispatch_async(dispatch_get_main_queue()) {
                                    eventImage = UIImage(data: decodedString!)!
                                    
                                    eventManager.addEvents(eventData["id"].intValue, name: eventData["title"].stringValue, picture: eventImage, date: eventData["event_time"].stringValue, genre: "id: " + eventData["id"].stringValue, location: eventData["location"].stringValue)
                                }
                            }
                        }
                        
                    })
                }
                
            }
            
            println("Data Loaded.")
        })
    }
}
