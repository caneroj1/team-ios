//
//  MessageManager.swift
//  MW
//
//  Created by Nick on 5/19/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//
import UIKit

struct Reply {
    var name: String = ""
    var subject: String = ""
    var messageHeight: CGFloat = 100
}


class MessageManager: NSObject {
    
    var isNearMeURL = false
    var isLoadingPeople = true
    var replies = [Reply]()
    var messageDelegate: MessageDelegate?
    
    func changeHeight(index: Int, height: CGFloat) {
        replies[index].messageHeight = height
    }
    
    func loadMessages(lower: Int, upper: Int) {
        
        isLoadingPeople = true
        
        var url: String? = "/api/users"
        
        DataManager.makeGetRequest(url!, completion: { (data, error) -> Void in
            let json = JSON(data: data!)
            
            for index in lower...upper {
                
                if index >= json.count {
                    println("loop broken.");
                    break;
                }
                
                println(json)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.messageDelegate!.addedNewMessage()
                println("Data Loaded.")
                
            }
            
        })
    }
}