//
//  ProfileViewController.swift
//  MusiciansWanted
//
//  Created by Nick on 3/11/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource, ContactTableDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Instances Variables and IB Outlets
    var needToLoadPicture = true
    var genderString: String?
    var searchRadius: Int = 10
    var userAge: Int?
    var noAge: Bool?
    var ageText = ""
    var hasCell = false
    var myCell: String?
    var contactsManager = ContactsDataManager()
    var arrGenre = [String]()
    var genre: String = ""
    
    // IB items for the main profile view
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var jamLabel: UILabel!
    @IBOutlet weak var bandLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editProfileButton: UIBarButtonItem!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var contactsTable: UITableView!
    @IBOutlet var genreCollection: UICollectionView!
    
    // MARK: - Image Functionality
    
    @IBAction func openCameraRoll(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func logOut(sender: UIButton) {
        
        SweetAlert().showAlert("Are you sure?", subTitle: "You'll have to log back in next time!", style: AlertStyle.Warning, buttonTitle:"Cancel", buttonColor:UIColorFromRGB(0xD0D0D0) , otherButtonTitle:  "Yes, log me out!", otherButtonColor: UIColorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
            if isOtherButton == true {
                
                return
            }
            else {
                //Store User information
                let defaults = NSUserDefaults.standardUserDefaults()
                
                defaults.setObject(nil, forKey: "userId")
                defaults.setObject(nil, forKey: "refreshToken")
                defaults.setObject(true, forKey: "locationServicesDisabled")
                defaults.setObject(nil, forKey: "longitude")
                defaults.setObject(nil, forKey: "latitude")
                
                let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("LogInViewController") as! LogInViewController
                self.presentViewController(viewController, animated: true, completion: nil)
            }
        }
        
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let newImage = Toucan(image: pickedImage).resizeByScaling(CGSizeMake(280, 140)).image as UIImage
        
        DataManager.uploadProfileImage("/api/s3ProfilePictureUpload", userID: MusiciansWanted.userId, image: newImage, completion: { (data, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                SweetAlert().showAlert("Sweet!", subTitle: "Profile picture successfully changed!", style: AlertStyle.Success)
                return
            }
        })
        
        profileImage.image = newImage
    }
    
    // MARK: - Contact Table Delegate
    func contactSaved() {
        dispatch_async(dispatch_get_main_queue()) {
            self.contactsTable.reloadData()
        }
    }
    
    // MARK: - API Requests
    
    func populateContacts() {
        contactsManager.contactDelegate = self
        contactsManager.populateContacts()
    }
    
    func populateProfile() {
        var url = "/api/users/\(MusiciansWanted.userId)"
        DataManager.makeGetRequest(url, completion: { (data, error) -> Void in
            var json = JSON(data: data!)
            dispatch_async(dispatch_get_main_queue()) {
                
                self.nameLabel.text = (json["name"] != nil) ? json["name"].stringValue : "No Name Given"
                self.emailLabel.text = json["email"].stringValue
                self.ageLabel.text = (json["age"] != nil) ? json["age"].stringValue : "No Age Given"
                
                if let age = self.ageLabel.text!.toInt() {
                    self.userAge = age
                }
                
                self.ageText = self.ageLabel.text!
                self.noAge = (self.ageLabel.text == "No Age Given")
                
                
                //Format and display the location
                if (json["location"] == nil || json["location"] == "") {
                    self.locationLabel.text = "No Location Given"
                }
                else {
                    var newLoc = (json["location"].stringValue).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    
                    var tmpArray1 : [String] = newLoc.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: "\n:"))
                    
                    if tmpArray1.count > 2 {
                        newLoc = tmpArray1[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    }
                    
                    
                    self.locationLabel.text = newLoc
                }
                
                self.jamLabel.text = json["looking_to_jam"] ? "Yes" : "No"
                self.bandLabel.text = json["looking_for_band"] ? "Yes" : "No"
                self.searchRadius = json["search_radius"].stringValue.toInt()!
                self.genderString = json["gender"].stringValue
                self.hasCell = (json["cell"].stringValue != "")

                if self.hasCell {
                    self.myCell = json["cell"].stringValue
                }
                
                if self.genderString != "none" {
                    self.ageLabel.text = "\(self.genderString!.capitalizedString), \(self.ageLabel.text!)"
                }
                
                self.genre = json["genre"].stringValue
                self.arrGenre = self.genre.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: ":"))
                
                self.genreCollection.reloadData()
                
                self.editProfileButton.enabled = true
            }
        })
    }
    
    func getProfileImage() {
        var url = "/api/s3ProfileGet?user_id=\(MusiciansWanted.userId)"
        DataManager.makeGetRequest(url, completion: { (data, error) -> Void in
            if data != nil {
                var json = JSON(data: data!)
                if json["picture"] != nil {
                    var base64String = json["picture"].stringValue
                    let decodedString = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                    var downloadedImage = UIImage(data: decodedString!)!
                    var newImage = Toucan(image: downloadedImage).resize(CGSizeMake(280, 140), fitMode: Toucan.Resize.FitMode.Scale).image

                    dispatch_async(dispatch_get_main_queue()) {
                        self.profileImage.image = newImage
                    }
                }
            }
            else {
                self.profileImage.image = UIImage(named: "anonymous")
            }
        })
    }
    
    // MARK: - Native Functions
    
    override func viewWillAppear(animated: Bool) {
        editProfileButton.enabled = false
        populateProfile()
        populateContacts()
        if needToLoadPicture {
            getProfileImage()
            needToLoadPicture = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        scrollView.contentSize.height = 600
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Contacts Table View
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(contactsManager.contacts)
        return contactsManager.contacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell") as! UITableViewCell
        cell.textLabel?.text = contactsManager.contacts[indexPath.row].name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let personView = self.storyboard?.instantiateViewControllerWithIdentifier("PersonViewController") as! PersonViewController
        
        personView.id = contactsManager.contacts[indexPath.row].id
        self.navigationController?.pushViewController(personView, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "editProfileSegue") {
            var destination = segue.destinationViewController as! EditProfileViewController
            destination.nameText = self.nameLabel.text!
            println(self.nameLabel.text!)
            destination.emailText = self.emailLabel.text!
            destination.radiusValue = Float(self.searchRadius)
            destination.radiusLabel = "\(self.searchRadius) miles"
            destination.gender = self.genderString!
            
            if noAge! {
                destination.ageText = "\(20)"
                destination.ageValue = 20
            }
            else {
                destination.ageText = self.ageText
                destination.ageValue = Float(self.userAge!)
            }
            
            if self.jamLabel.text == "No" {
                destination.jamBool = false
            }
            else {
                destination.jamBool = true
            }
            
            if self.bandLabel.text == "No" {
                destination.bandBool = false
            }
            else {
                destination.bandBool = true
            }
            
            if hasCell {
                destination.cellSent = true
                let cellString = myCell! as NSString
                let firstThree = cellString.substringWithRange(NSMakeRange(1, 3))
                let secondThree = cellString.substringWithRange(NSMakeRange(4, 3))
                let lastFour = cellString.substringWithRange(NSMakeRange(7, 4))
                destination.cellPhone = "\(firstThree)-\(secondThree)-\(lastFour)"
            }
            else {
                destination.cellSent = false
            }
            
            destination.genre = genre
        }
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
            
            cell.imgEditGenre.image = UIImage(named: imageName)
            
            return cell
            
        //}
        
    }

}
