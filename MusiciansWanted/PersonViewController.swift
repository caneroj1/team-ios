//
//  PersonViewController.swift
//  MW
//
//  Created by Joseph Canero on 4/11/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var personIcon: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var jamLabel: UILabel!
    @IBOutlet weak var bandLabel: UILabel!
    @IBOutlet weak var locationlabel: UILabel!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet var genreCollection: UICollectionView!
    
    var icon: UIImage?
    var controller: String?
    var id: Int?
    
    let darkenedColor = UIColor(red: 200.0/255.0, green: 90.0/255.0, blue: 0.0/255.0, alpha: 0.5)
    let brightColor = UIColor(red: 255.0/255.0, green: 90.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    
    var arrGenre = [String]()
    var genre: String = ""
    
    override func viewWillAppear(animated: Bool) {
        contactButton.hidden = true
        
        let url1 = "/api/users/\(id!)"
        DataManager.makeGetRequest(url1, completion: { (data, error) -> Void in
            let json = JSON(data: data!)
            dispatch_async(dispatch_get_main_queue()) {
                self.personName.text = json["name"].stringValue
                self.emailLabel.text = json["email"].stringValue
                self.jamLabel.text = json["looking_to_jam"] ? "Yes" : "No"
                self.bandLabel.text = json["looking_for_band"] ? "Yes" : "No"
                self.ageLabel.text = json["age"].stringValue
                
                //Format and display the location
                if (json["location"] == nil || json["location"] == "") {
                    self.locationlabel.text = "No Location Given"
                }
                else {
                    self.locationlabel.text = DataManager.formatLocation(json["location"].stringValue)
                }
                
                self.title = self.personName.text
                
                let gender = json["gender"].stringValue
                if gender == "male" {
                    self.ageLabel.text = "Male, \(self.ageLabel.text!)"
                }
                else if gender == "female" {
                    self.ageLabel.text = "Female, \(self.ageLabel.text!)"
                }
                
                self.genre = json["genre"].stringValue
                self.arrGenre = self.genre.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: ":"))
                
                self.genreCollection.reloadData()
                
            }
            
            if let presenter = self.controller {
                if presenter == "people" {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.personIcon.image = self.icon
                    }
                }
            }
            else {
                if json["has_profile_pic"].stringValue == "true" {
                    DataManager.makeGetRequest("/api/s3ProfileGet?user_id=\(self.id!)", completion: { (data, error) -> Void in
                        var picData = JSON(data: data!)
                        if picData["picture"] != nil {
                            var base64String = picData["picture"].stringValue
                            let decodedString = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                            var downloadedImage: UIImage = UIImage(data: decodedString!)!
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                self.personIcon.image = Toucan(image: downloadedImage).maskWithRoundedRect(cornerRadius: 20.0, borderWidth: 1.0, borderColor: UIColor.clearColor()).image
                            }
                        }
                    })
                }
                else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.personIcon.image = Toucan(image: UIImage(named: "anonymous")!).maskWithRoundedRect(cornerRadius: 20.0, borderWidth: 1.0, borderColor: UIColor.clearColor()).image
                    }
                }
            }
        })
        
        let url2 = "/api/contactships/contacts/\(MusiciansWanted.userId)/knows/\(id!)"
        DataManager.makeGetRequest(url2, completion: { (data, error) -> Void in
            let json = JSON(data: data!)
            dispatch_async(dispatch_get_main_queue()) {
                self.contactButton.hidden = false
                if json["knows"] == true || self.id == MusiciansWanted.userId {
                    self.contactButton.backgroundColor = self.darkenedColor
                    self.contactButton.enabled = false
                }
                else {
                    self.contactButton.backgroundColor = self.brightColor
                    self.contactButton.enabled = true
                }
            }
        })
    }
    
    @IBAction func addToContacts(sender: UIButton) {
        let url = "/api/contactships"
        let contactParams = ["user_id": "\(MusiciansWanted.userId)", "contact_id": "\(id!)"]

        DataManager.makePostRequest(url, params: contactParams, completion: { (data, error) -> Void in
            let json = JSON(data: data!)
            let errorString = DataManager.checkForErrors(json)
            if errorString == "" {
                dispatch_async(dispatch_get_main_queue()) {
                    sender.enabled = false
                    sender.backgroundColor = self.darkenedColor
                    if MusiciansWanted.contacts?.findKey(self.id!) == nil {
                        MusiciansWanted.contacts?.insertKey(self.id!, data: true)
                    }
                }
            }
            else {
                dispatch_async(dispatch_get_main_queue()) {
                    SweetAlert().showAlert("Uh oh!", subTitle: "There was a problem with the contact request. Try again later!", style: AlertStyle.Error)
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        //if genreCollection == collectionView {
        return arrGenre.count
        //}
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //if genreCollection == collectionView {
        
        let cell: GenreCell = collectionView.dequeueReusableCellWithReuseIdentifier("genreCell", forIndexPath: indexPath) as! GenreCell
        
        var imageName: String = "btn" + arrGenre[indexPath.row]
        
        println(imageName)
        cell.imgEditGenre.image = UIImage(named: imageName)
        
        return cell
        
        //}
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
