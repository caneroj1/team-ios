//
//  PersonViewController.swift
//  MW
//
//  Created by Joseph Canero on 4/11/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController {
    @IBOutlet weak var personIcon: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var jamLabel: UILabel!
    @IBOutlet weak var bandLabel: UILabel!
    @IBOutlet weak var locationlabel: UILabel!
    
    var icon: UIImage?
    var controller: String?
    var id: Int?
    
    override func viewWillAppear(animated: Bool) {
        let url = "/api/users/\(id!)"
        DataManager.makeGetRequest(url, completion: { (data, error) -> Void in
            let json = JSON(data: data!)
            dispatch_async(dispatch_get_main_queue()) {
                self.personName.text = json["name"].stringValue
                self.emailLabel.text = json["email"].stringValue
                self.jamLabel.text = json["looking_to_jam"].stringValue
                self.bandLabel.text = json["looking_for_band"].stringValue
                self.ageLabel.text = json["age"].stringValue
                self.locationlabel.text = json["location"].stringValue
                
                let gender = json["gender"].stringValue
                if gender == "male" {
                    self.ageLabel.text = "Male, \(self.ageLabel.text)"
                }
                else if gender == "female" {
                    self.ageLabel.text = "Female, \(self.ageLabel.text)"
                }
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
                    DataManager.makeGetRequest("/api/s3get?id=\(self.id!)", completion: { (data, error) -> Void in
                        var picData = JSON(data: data!)
                        if picData["picture"] != nil {
                            var base64String = json["picture"].stringValue
                            let decodedString = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                            var downloadedImage = UIImage(data: decodedString!)!
                            var newImage = Toucan(image: downloadedImage).resize(CGSizeMake(280, 140), fitMode: Toucan.Resize.FitMode.Scale).image
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                self.personIcon.image = newImage
                            }
                        }
                    })
                }
                else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.personIcon.image = UIImage(named: "anonymous")
                    }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
