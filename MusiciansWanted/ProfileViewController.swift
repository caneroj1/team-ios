//
//  ProfileViewController.swift
//  MusiciansWanted
//
//  Created by Nick on 3/11/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // IB items for the main profile view
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func openCameraRoll(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let pickedImage = info[UIImagePickerControllerOriginalImage] as UIImage
        profileImage.image = Toucan(image: pickedImage).resizeByScaling(CGSizeMake(140, 140)).image
    }
    
    func populateProfile() {
        var url = "/api/users/\(MusiciansWanted.userId)"
        DataManager.makeGetRequest(url, completion: { (data, error) -> Void in
            var json = JSON(data: data!)
            dispatch_async(dispatch_get_main_queue()) {
                self.nameLabel.text = (json["name"] != nil) ? json["name"].stringValue : "No Name Given"
                self.emailLabel.text = json["email"].stringValue
                self.ageLabel.text = (json["age"] != nil) ? json["age"].stringValue : "No Age Given"
                self.locationLabel.text = (json["location"] != nil) ? json["location"].stringValue : "No Location Given"
            }
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        populateProfile()
//        profileImage.image = UIImage(named: "anonymous")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "editProfileSegue") {
            var destination = segue.destinationViewController as EditProfileViewController
            destination.nameText = self.nameLabel.text!
            destination.emailText = self.emailLabel.text!
            
            if self.ageLabel.text == "No Age Given" {
                destination.ageText = "\(20)"
                destination.ageValue = 20
            }
            else {
                destination.ageText = self.ageLabel.text!
                var str = NSString(string: self.ageLabel.text!)
                destination.ageValue = str.floatValue
            }
            
            if self.locationLabel.text == "No Location Given" {
                destination.locationBool = false
            }
            else {
                destination.locationBool = true
            }
        }
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