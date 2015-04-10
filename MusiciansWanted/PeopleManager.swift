import UIKit
import CoreLocation

//var pplMgr: PeopleManager = PeopleManager()

struct people {
    var id = 0
    var profname = "Un-named"
    var profpic = UIImage(named: "anonymous")
    var age = "None"
    var genre = "None"
    var instrument = "None"
    var location = "Unknown"
    var distance = 0.01
    var looking_for_band = false
    var looking_to_jam = false
    var indexPth: NSIndexPath = NSIndexPath();
}

class PeopleManager: NSObject {
    
    var isNearMeURL = false
    var isLoadingPeople = false
    var isProcessComplete = false
    var arrPerson = [Int]()
    var person = [Int:people]()
    var peopleDelegate: PeopleDelegate?
    
    func addPerson(id: Int, name: String, pic: UIImage, age: String, genre: String, instru: String, loc: String, distance: Double, band: Bool, jam: Bool){
        
        var tempPerson: people = people()
        
        tempPerson.id = id;
        tempPerson.profname = name;
        tempPerson.profpic = pic;
        tempPerson.age = age;
        tempPerson.genre = genre;
        tempPerson.instrument = instru;
        tempPerson.location = loc;
        tempPerson.distance = distance
        tempPerson.looking_for_band = band
        tempPerson.looking_to_jam = jam
        
        person[id] = tempPerson;
        //person.updateValue(tempPerson, forKey: id)
    }
    
    func loadPeople(lower: Int, upper: Int) {
        
        isLoadingPeople = true
        
        var url: String?
        
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedWhenInUse:
            url = "/api/users/\(MusiciansWanted.userId)/near_me"
            isNearMeURL = true
        case .Restricted, .Denied, .AuthorizedAlways, .NotDetermined:
            url = "/api/users"
            isNearMeURL = false
        }
        
        DataManager.makeGetRequest(url!, completion: { (data, error) -> Void in
            let json = JSON(data: data!)
            
            if self.isNearMeURL {
                for user in json {
                    self.addUser(user.1)
                }
                
            }
            else {
                for index in lower...upper {
                    
                    if index >= json.count {
                        println("loop broken.");
                        break;
                    }
                    
                    self.addUser(json[index])

                }

            }
            
            dispatch_sync(dispatch_get_main_queue()) {
                
                self.arrPerson = Array(self.person.keys).sorted(<)
                
                self.isLoadingPeople = false
                self.isProcessComplete = true
                self.peopleDelegate!.addedNewItem()
                println("Data Loaded.")
                
            }
            
        })
    }
    
    func addUser(user: JSON) {
        var userId = user["id"];
        
        //write if statement that filters setting based on age, looking to jam, and band
        //Add basic information of users
        var profileImage = UIImage(named: "anonymous")!
        
        self.addPerson(user["id"].intValue, name: user["name"].stringValue, pic: profileImage, age: user["age"].stringValue, genre: "Unknown", instru: "Unknown", loc: user["location"].stringValue, distance: user["distance"].doubleValue, band: user["looking_for_band"].boolValue, jam: user["looking_to_jam"].boolValue)
        
        println("Adding user \(userId)");
        
        
        //Load in profile images
        if user["has_profile_pic"].stringValue == "true"
        {
            println("loading profile picture of \(userId)");
            var url = "/api/s3get?user_id=\(userId)"
            DataManager.makeGetRequest(url, completion: { (data, error) -> Void in
                if data != nil {
                    var json = JSON(data: data!)
                    if json["picture"] != nil {
                        var base64String = json["picture"].stringValue
                        let decodedString = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                        dispatch_sync(dispatch_get_main_queue()) {
                            profileImage = UIImage(data: decodedString!)!
                            
                            self.addPerson(user["id"].intValue, name: user["name"].stringValue, pic: profileImage, age: user["age"].stringValue, genre: "Unknown", instru: "Unknown", loc: user["location"].stringValue, distance: user["distance"].doubleValue, band: user["looking_for_band"].boolValue, jam: user["looking_to_jam"].boolValue)
                        }
                    }
                }
                
            })
        }
        
    }
    
}