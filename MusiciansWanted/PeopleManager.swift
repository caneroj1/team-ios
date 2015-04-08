import UIKit
import CoreLocation

var pplMgr: PeopleManager = PeopleManager()

struct people {
    var id = 0
    var profname = "Un-named"
    var profpic = UIImage(named: "anonymous")
    var age = "None"
    var genre = "None"
    var instrument = "None"
    var location = "Unknown"
}

class PeopleManager: NSObject {
    
    var person = [people]()
    
    func addPerson(id: Int, name: String, pic: UIImage, age: String, genre: String, instru: String, loc: String){
        
        if person.count >= id {
            person[id-1].profname = name;
            person[id-1].profpic = pic;
            person[id-1].age = age;
            person[id-1].genre = genre;
            person[id-1].instrument = instru;
            person[id-1].location = loc;
        }
        else {
            person.append(people(id: id, profname: name, profpic: pic, age: age, genre: genre, instrument: instru, location: loc))
        }
    }
    
    func loadPeople(lower: Int, upper: Int) {
        var url: String?
        
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedWhenInUse:
            url = "/api/users/\(MusiciansWanted.userId)/near_me"
        case .Restricted, .Denied, .AuthorizedAlways, .NotDetermined:
            url = "/api/users"
        }
        
        DataManager.makeGetRequest(url!, completion: { (data, error) -> Void in
            let json = JSON(data: data!)
            
            //for user in json {
            for index in lower...upper {
                
                if index >= json.count {
                    
                    break;
                }
                var user = json[index]
                var userId = user["id"];

                //write if statement that filters setting based on age, looking to jam, and band
                //Add basic information of users
                var profileImage = UIImage(named: "anonymous")!
                
                pplMgr.addPerson(user["id"].intValue, name: user["name"].stringValue, pic: profileImage, age: user["age"].stringValue, genre: "id: " + user["id"].stringValue, instru: "Unknown", loc: user["location"].stringValue)
                
                
                
                
                //Load in profile images
                if user["has_profile_pic"].stringValue == "true"
                {
                    
                    var url = "/api/s3get?user_id=\(userId)"
                    DataManager.makeGetRequest(url, completion: { (data, error) -> Void in
                        if data != nil {
                            var json = JSON(data: data!)
                            if json["picture"] != nil {
                                var base64String = json["picture"].stringValue
                                let decodedString = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                                dispatch_async(dispatch_get_main_queue()) {
                                    profileImage = UIImage(data: decodedString!)!
                                
                                    pplMgr.addPerson(user["id"].intValue, name: user["name"].stringValue, pic: profileImage, age: user["age"].stringValue, genre: "id: " + user["id"].stringValue, instru: "Unknown", loc: user["location"].stringValue)
                                }
                            }
                        }
                    
                    })
                }
                
            }
            
            
        })
    }
}