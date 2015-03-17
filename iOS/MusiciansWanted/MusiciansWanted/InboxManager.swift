import UIKit

var inboxMgr: InboxManager = InboxManager()

struct inbox {
    var name = "Un-named"
    var subject = "None"
    var time = "Un-Dated"
}

class InboxManager: NSObject {
    
    var messages = [inbox]()
    
    func addMessage(name: String, subject: String, time: String){
        messages.append(inbox(name: name, subject: subject, time: time))
    }
}