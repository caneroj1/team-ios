import UIKit

var pplMgr: PeopleManager = PeopleManager()

struct people {
    var profname = "Un-named"
    var profpic = UIImage(named: "anonymous")
    var age = "None"
    var genre = "None"
    var instrument = "None"
    var location = "Unknown"
}

class PeopleManager: NSObject {
    
    var person = [people]()
    
    func addPerson(name: String, pic: UIImage, age: String, genre: String, instru: String, loc: String){
        person.append(people(profname: name, profpic: pic, age: age, genre: genre, instrument: instru, location: loc))
    }
}