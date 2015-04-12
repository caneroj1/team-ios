//
//  ProfileViewController.swift
//  MusiciansWanted
//
//  Created by Nick on 3/11/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    // MARK: - Instances Variables and IB Outlets
    
    var needToLoadPicture = true
    var genderString: String?
    var searchRadius: Int = 10
    var userAge: Int?
    var noAge: Bool?
    var ageText = ""
    
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
    
    // MARK: - Image Functionality
    
    @IBAction func openCameraRoll(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let newImage = Toucan(image: pickedImage).resizeByScaling(CGSizeMake(280, 140)).image as UIImage
        
        DataManager.uploadImage("/api/s3upload", userID: MusiciansWanted.userId, image: newImage, completion: { (data, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                SweetAlert().showAlert("Sweet!", subTitle: "Profile picture successfully changed!", style: AlertStyle.Success)
                return
            }
        })
        
        profileImage.image = newImage
    }
    
    // MARK: - API Requests
    
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
                
                self.locationLabel.text = (json["location"] != nil) ? json["location"].stringValue : "No Location Given"
                self.jamLabel.text = json["looking_to_jam"] ? "Yes" : "No"
                self.bandLabel.text = json["looking_for_band"] ? "Yes" : "No"
                self.searchRadius = json["search_radius"].stringValue.toInt()!
                self.genderString = json["gender"].stringValue

                if self.genderString != "none" {
                    self.ageLabel.text = "\(self.genderString!.capitalizedString), \(self.ageLabel.text!)"
                }
                
                self.editProfileButton.enabled = true
            }
        })
    }
    
    func getProfileImage() {
        var url = "/api/s3get?user_id=\(MusiciansWanted.userId)"
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
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "editProfileSegue") {
            var destination = segue.destinationViewController as! EditProfileViewController
            destination.nameText = self.nameLabel.text!
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
        }
    }
}
