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
    var isExpanded: Bool
}

class InboxManager: NSObject {
    
    var messageDictionary = [Int:inbox]()
    var messages = [Int]()
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
                        
                        self.messageDictionary[msg.1["id"].intValue] = inbox(id: msg.1["id"].intValue, name: name, subject: msg.1["subject"].stringValue, date: strdate, body: msg.1["body"].stringValue, senderId: msg.1["sent_by"].intValue, receiverId: msg.1["user_id"].intValue, profpic: UIImage(named: "anonymous")!, cellHeight: 85, isExpanded: false)
                        
                        self.getImage(msg.1,user: user_json)
                        
                        println(name)
                        self.messageDelegate?.addedNewMessage()
                        self.messages = Array(self.messageDictionary.keys).sorted(<)


                    }
                })
            }

        })
    }
    
    func getImage(msg: JSON, user: JSON) {
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
                            
                            self.messageDictionary[msg["id"].intValue]?.profpic = profileImage
                            
                            println("loaded image of \(userId)")
                            self.messageDelegate!.addedNewMessage()
                        }
                    }
                }
                
            })
        }

    }
}