//
//  MessageManager.swift
//  MW
//
//  Created by Nick on 5/19/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//
import UIKit

struct Reply {
    var id: Int = -1
    var messageId = -1
    var userId = -1
    var name: String = ""
    var body: String = ""
    var date: String = ""
    var messageHeight: CGFloat = 100
}


class MessageManager: NSObject {
    
    var isNearMeURL = false
    var replies = [String: Reply]()
    var replyIndex = [String]()
    var messageDelegate: MessageDelegate?
    
    func changeHeight(index: Int, height: CGFloat) {
        replies[replyIndex[index]]!.messageHeight = height
    }
    
    func loadMessages(messageId: Int, lower: Int, upper: Int) {
        let constantIndex = replies.count
        
        var url: String = "/api/messages/\(messageId)/replies"
                
        DataManager.makeGetRequest(url, completion: { (data, error) -> Void in
            let morejson = JSON(data: data!)
            
            for index in morejson {
                
                /*if index >= morejson.count {
                    println("loop broken.");
                    break;
                }*/
                
                let json = index.1
                
                self.replies[json["created_at"].stringValue] = Reply(id: json["id"].intValue, messageId: json["message_id"].intValue, userId: json["user_id"].intValue, name: "Received", body: json["body"].stringValue, date: json["created_at"].stringValue, messageHeight: 100)
                
                let sender_id = json["user_id"].intValue
                self.getName(json["created_at"].stringValue, sender_id: sender_id)

            }
            
            dispatch_async(dispatch_get_main_queue()) {
                if self.replies.count > constantIndex {
                    self.messageDelegate!.addedNewMessage()
                    self.replyIndex = Array(self.replies.keys).sorted(<)
                }
            }
            
        })
    }
    
    func getName(date_id: String, sender_id: Int) {
        var user_url = "/api/users/\(sender_id)"
        
        DataManager.makeGetRequest(user_url, completion: { (data, error) -> Void in
            var user_json = JSON(data: data!)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                let newname = user_json["name"].stringValue
                self.replies[date_id]?.name = newname
            }
        })

    }
}