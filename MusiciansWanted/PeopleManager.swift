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
    var email = ""
    var indexPth: NSIndexPath = NSIndexPath();
    var gender = ""
}

struct Filters {
    static var genre = ""
    static var instrument = ""
    static var looking_for_band = false
    static var looking_to_jam = false
    static var contactsOnly = false
    static var lowerAge = 13
    static var upperAge = 75
}


class PeopleManager: NSObject {
    
    var isNearMeURL = false
    var isLoadingPeople = true
    var arrPerson = [Int]()
    var person = [Int:people]()
    var peopleDelegate: PeopleDelegate?
    
    func addPerson(id: Int, name: String, pic: UIImage, age: String, genre: String, instru: String, loc: String, distance: Double, band: Bool, jam: Bool, email: String, gender: String){
        
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
        tempPerson.email = email
        tempPerson.gender = gender
        
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
            
            println(json)
            
            if self.isNearMeURL {
                for user in json {
                    
                    //------- Check Filters -------
                    // Still need to check contactsOnly, genres, and instruments
                    var tmp = user.1["name"].stringValue
                    
                    var isGenresMatch = true
                    
                    if Filters.genre != "" {
                        
                        println(Filters.genre)
                        println(user.1["genre"].stringValue)
                        
                        var arrGenres : [String] = (dropLast(Filters.genre)).componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: ":"))
                        
                        for genre in arrGenres {
                            if ((user.1["genre"].stringValue).rangeOfString(genre) == nil) {
                                isGenresMatch = false
                                
                                println(genre + " not found")
                            }
                            println(genre + " found")
                        }
                    }
                    
                    if (Filters.looking_for_band && user.1["looking_for_band"].boolValue == false) || (Filters.looking_to_jam && user.1["looking_to_jam"].boolValue == false) || (user.1["age"].stringValue != "" && (Filters.lowerAge > user.1["age"].intValue || Filters.upperAge < user.1["age"].intValue)) || isGenresMatch == false {
                        
                        println("\(tmp) not added.")
                        self.person.removeValueForKey(user.1["id"].intValue)
                        
                    }
                    else {
                        if(self.person.indexForKey(user.1["id"].intValue) != nil) {
                            println("user not added")
                        }
                        else {
                            self.addUser(user.1)
                            println("USER ADD : \(tmp)")
                        }
                    }
                }
                
            }
            else {
                for index in lower...upper {
                    
                    if index >= json.count {
                        println("loop broken.");
                        break;
                    }
                    
                    //Check Filters
                    var isGenresMatch = true
                    
                    if Filters.genre != "" {
                        
                        var arrGenres : [String] = (Filters.genre).componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: ":"))
                        
                        for genre in arrGenres {
                            if ((json[index]["genre"].stringValue).rangeOfString(genre) == nil) {
                                isGenresMatch = false
                            }
                        }
                    }
                    
                    var tmp = json[index]["name"].stringValue
                    
                    if (Filters.looking_for_band && json[index]["looking_for_band"].boolValue == false) || (Filters.looking_to_jam && json[index]["looking_to_jam"].boolValue == false) || (json[index]["age"].stringValue != "" && (Filters.lowerAge > json[index]["age"].intValue || Filters.upperAge < json[index]["age"].intValue)) || isGenresMatch == false {
                        
                        println("\(tmp) not added.")
                        self.person.removeValueForKey(json[index]["id"].intValue)
                    }
                    else {
                        if((self.person.indexForKey(json[index]["id"].intValue)) != nil) {
                            println("user not added")
                        }
                        else {
                            self.addUser(json[index])
                            println("USER ADD : \(tmp)")
                        }
                    }
                    
                }
                
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.arrPerson = Array(self.person.keys)
                self.sortByDistance(0, higherIndex: self.arrPerson.count - 1)
                
                self.isLoadingPeople = false
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
        
        self.addPerson(user["id"].intValue, name: user["name"].stringValue, pic: profileImage, age: user["age"].stringValue, genre: user["genre"].stringValue, instru: "Unknown", loc: user["location"].stringValue, distance: user["distance"].doubleValue, band: user["looking_for_band"].boolValue, jam: user["looking_to_jam"].boolValue, email: user["email"].stringValue, gender: user["gender"].stringValue)
        
        println("Adding user \(userId)");
        
        //Load in profile images
        if user["has_profile_pic"].stringValue == "true"
        {
            println("loading profile picture of \(userId)");
            var url = "/api/s3ProfileGet?user_id=\(userId)"
            DataManager.makeGetRequest(url, completion: { (data, error) -> Void in
                if data != nil {
                    var json = JSON(data: data!)
                    if json["picture"] != nil {
                        var base64String = json["picture"].stringValue
                        let decodedString = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                        dispatch_async(dispatch_get_main_queue()) {
                            profileImage = UIImage(data: decodedString!)!
                            
                            self.addPerson(user["id"].intValue, name: user["name"].stringValue, pic: profileImage, age: user["age"].stringValue, genre: user["genre"].stringValue, instru: "Unknown", loc: user["location"].stringValue, distance: user["distance"].doubleValue, band: user["looking_for_band"].boolValue, jam: user["looking_to_jam"].boolValue, email: user["email"].stringValue, gender: user["gender"].stringValue)
                            
                            println("loaded image of \(userId)")
                            self.peopleDelegate!.addedNewItem()
                        }
                    }
                }
                
            })
        }
        
        println("added user \(userId)")
        
    }
    
    //Merge Sort arrPerson by distance values
    func sortByDistance(lowerIndex: Int, higherIndex: Int) {
        var i = lowerIndex;
        var j = higherIndex;
        // calculate pivot number
        var pivot = person[arrPerson[lowerIndex+(higherIndex-lowerIndex)/2]]!.distance
        // Divide into two arrays
        while (i <= j) {
            while (person[arrPerson[i]]!.distance < pivot) {
                i++;
            }
            while (person[arrPerson[j]]!.distance > pivot) {
                j--;
            }
            if (i <= j) {
                //exchangeNumbers(i, j);
                var temp = arrPerson[i];
                arrPerson[i] = arrPerson[j];
                arrPerson[j] = temp;
                
                //move index to next position on both sides
                i++;
                j--;
            }
        }
        // call method recursively
        if (lowerIndex < j) {
            sortByDistance(lowerIndex, higherIndex: j);
        }
        if (i < higherIndex) {
            sortByDistance(i, higherIndex: higherIndex);
        }
    }
}