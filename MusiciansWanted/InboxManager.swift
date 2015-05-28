import UIKit

struct inbox {
    var id = -1
    var name = ""
    var subject = ""
    var date = ""
    var body = ""
    var senderId = -1
    var receiverId = -1
    var profpic: UIImage
    var cellHeight: CGFloat
    var read = true
}

class InboxManager: NSObject {
    
    var messageDictionary = [String:inbox]()
    var messages = [String]()
    var sent_messageDictionary = [String:inbox]()
    var sent_messages = [String]()
    var messageDelegate: MessageDelegate?
    
    func loadInbox() {
        var url = "/api/users/\(MusiciansWanted.userId)/messages"
    
        DataManager.makeGetRequest(url, completion: { (data, error) -> Void in
            let json = JSON(data: data!)
                        
            for msg in json {
                var sender_id = msg.1["sent_by"].intValue
                var user_url = "/api/users/\(sender_id)"
                
                DataManager.makeGetRequest(user_url, completion: { (data, error) -> Void in
                    var user_json = JSON(data: data!)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        var name = (user_json["name"] != nil) ? user_json["name"].stringValue : "No Name Given"
                        
                        let strdate = msg.1["created_at"].stringValue
                        
                        self.messageDictionary[msg.1["created_at"].stringValue] = inbox(id: msg.1["id"].intValue, name: name, subject: msg.1["subject"].stringValue, date: strdate, body: msg.1["body"].stringValue, senderId: msg.1["sent_by"].intValue, receiverId: msg.1["user_id"].intValue, profpic: UIImage(named: "anonymous")!, cellHeight: 85, read: msg.1["seen_by_receiver"].boolValue)
                        
                        
                        self.getImage(msg.1,user: user_json, isSent: false)
                        
                        self.messageDelegate?.addedNewMessage()
                        self.messages = Array(self.messageDictionary.keys).sorted(>)


                    }
                })
            }

        })
    }
    
    func loadSent() {
        var url = "/api/users/\(MusiciansWanted.userId)/sent_messages"
        
        DataManager.makeGetRequest(url, completion: { (data, error) -> Void in
            let json = JSON(data: data!)
            
            for msg in json {
                var receiver_id = msg.1["user_id"].intValue
                var user_url = "/api/users/\(receiver_id)"
                
                DataManager.makeGetRequest(user_url, completion: { (data, error) -> Void in
                    var user_json = JSON(data: data!)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        var name = (user_json["name"] != nil) ? user_json["name"].stringValue : "No Name Given"
                        
                        let strdate = msg.1["created_at"].stringValue
                        
                        self.sent_messageDictionary[msg.1["created_at"].stringValue] = inbox(id: msg.1["id"].intValue, name: name, subject: msg.1["subject"].stringValue, date: strdate, body: msg.1["body"].stringValue, senderId: msg.1["sent_by"].intValue, receiverId: msg.1["user_id"].intValue, profpic: UIImage(named: "anonymous")!, cellHeight: 85, read: msg.1["seen_by_sender"].boolValue)
                        
                        self.getImage(msg.1,user: user_json, isSent: true)
                        
                        self.messageDelegate?.addedNewMessage()
                        self.sent_messages = Array(self.sent_messageDictionary.keys).sorted(>)
                        
                    }
                })
            }
            
        })
    }

    //There's definitely a much more efficient way of doing this
    func formatDate(strDate: String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        
        let offset = Double(formatter.timeZone.secondsFromGMT)
        let date = (formatter.dateFromString(strDate))!.dateByAddingTimeInterval(offset)
        
        let currentdate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        
        //Get current date information
        let currentcomponent = calendar.components(.CalendarUnitDay | .CalendarUnitYear | .CalendarUnitMonth, fromDate: currentdate)
        let currentday = currentcomponent.day
        let currentyear = currentcomponent.year
        let currentmonth = currentcomponent.month
        
        //Get message date information
        let messagecomponent = calendar.components(.CalendarUnitDay | .CalendarUnitYear | .CalendarUnitMonth, fromDate: date)
        let messageday = messagecomponent.day
        let messageyear = messagecomponent.year
        let messagemonth = messagecomponent.month
        
        let outputter = NSDateFormatter()
        
        //Determine how to format
        if currentyear == messageyear && currentmonth == messagemonth {
            if currentday == messageday {
                outputter.timeStyle = NSDateFormatterStyle.ShortStyle
                outputter.dateStyle = NSDateFormatterStyle.NoStyle
                
            }
            else if currentday - messageday < 7 {
                outputter.dateFormat = "EEEE"
            }
            else {
                outputter.dateStyle = NSDateFormatterStyle.ShortStyle
                outputter.timeStyle = NSDateFormatterStyle.NoStyle
            }
            
        }
        else {
            outputter.dateStyle = NSDateFormatterStyle.ShortStyle
            outputter.timeStyle = NSDateFormatterStyle.NoStyle
        }
        
        return outputter.stringFromDate(date)
    }

    func getImage(msg: JSON, user: JSON, isSent: Bool) {
        if user["has_profile_pic"].stringValue == "true"
        {
            var userId = user["id"].intValue
            var url = "/api/s3ProfileGet?user_id=\(userId)"
            DataManager.makeGetRequest(url, completion: { (data, error) -> Void in
                if data != nil {
                    var json = JSON(data: data!)
                    if json["picture"] != nil {
                        var base64String = json["picture"].stringValue
                        let decodedString = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                        dispatch_async(dispatch_get_main_queue()) {
                            var profileImage = UIImage(data: decodedString!)!
                            
                            if isSent == false {
                                self.messageDictionary[msg["updated_at"].stringValue]?.profpic = profileImage
                            }
                            else {
                                self.sent_messageDictionary[msg["updated_at"].stringValue]?.profpic = profileImage
                            }
                            
                            self.messageDelegate!.addedNewMessage()
                        }
                    }
                }
                
            })
        }

    }
}