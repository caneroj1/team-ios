import UIKit

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
    
    func loadPeople(){
        
        DataManager.makeGetRequest("/api/users", completion: { (data, error) -> Void in
            let json = JSON(data: data!)
            
            // replace with for index in lowerBound..upperBound
            // I would assume something like var user = json[index].1 next
            // replace all user.1 with just user
            for user in json {
                
                //write if statement that filters setting based on age, looking to jam, and band
                var profileImage = UIImage(named: "anonymous")!
                
                pplMgr.addPerson(user.1["id"].intValue, name: user.1["name"].stringValue, pic: profileImage, age: user.1["age"].stringValue, genre: "id: " + user.1["id"].stringValue, instru: "Unknown", loc: user.1["location"].stringValue)
                
                if user.1["has_profile_pic"].stringValue == "true"
                {
                    var userId = user.1["id"];
                    println("loading profile picture of \(userId)");
                    var url = "/api/s3get?user_id=\(userId)"
                    DataManager.makeGetRequest(url, completion: { (data, error) -> Void in
                        if data != nil {
                            var json = JSON(data: data!)
                            if json["picture"] != nil {
                                var base64String = json["picture"].stringValue
                                let decodedString = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                                dispatch_async(dispatch_get_main_queue()) {
                                    profileImage = UIImage(data: decodedString!)!
                                
                                    pplMgr.addPerson(user.1["id"].intValue, name: user.1["name"].stringValue, pic: profileImage, age: user.1["age"].stringValue, genre: "id: " + user.1["id"].stringValue, instru: "Unknown", loc: user.1["location"].stringValue)
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