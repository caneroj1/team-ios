//
//  PersonViewController.swift
//  MW
//
//  Created by Joseph Canero on 4/11/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    
    var eventLocation = ""
    
    @IBOutlet var lblEventName: UILabel!
    @IBOutlet var btnEventDate: UIButton!
    @IBOutlet var btnEventLocation: UIButton!
    @IBOutlet var btnEventCreated: UIButton!
    @IBOutlet var lblEventDescription: UITextView!
    @IBOutlet var imgEvent: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var btnEdit: UIBarButtonItem!
    
    
    var icon: UIImage?
    var controller: String?
    var id: Int?
    var userID = 1
    var userImage = UIImage(named: "anonymous")
    
    @IBAction func clickEdit(sender: UIBarButtonItem) {
        let editEventView = self.storyboard?.instantiateViewControllerWithIdentifier("AddEvent") as! AddEventViewController
        
        //personView.controller = "people"
        editEventView.eventdescription = lblEventDescription.text
        editEventView.eventID = id!
        editEventView.eventtitle = lblEventName.text!
        editEventView.eventLocation = eventLocation
        editEventView.eventDate = (btnEventDate.titleLabel?.text)!
        
        self.navigationController?.pushViewController(editEventView, animated: true)

    }
    
    override func viewWillAppear(animated: Bool) {
        btnEdit.enabled = false
        
        let url = "/api/events/\(id!)"
        
        DataManager.makeGetRequest(url, completion: { (data, error) -> Void in
            let json = JSON(data: data!)
            // we need to put error checking here in case the event doesn't exist
            // if the event doesn't exist, data = nil
            dispatch_async(dispatch_get_main_queue()) {
                
                self.lblEventDescription.text = json["description"].stringValue
                self.lblEventName.text = json["title"].stringValue
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
                
                let outputter = NSDateFormatter()
                outputter.dateStyle = NSDateFormatterStyle.ShortStyle
                outputter.timeStyle = NSDateFormatterStyle.ShortStyle
                
                let offset = Double(formatter.timeZone.secondsFromGMT)
                let newDateObject = formatter.dateFromString(json["event_time"].stringValue)?.dateByAddingTimeInterval(offset)
                
                self.btnEventDate.setTitle(outputter.stringFromDate(newDateObject!), forState: UIControlState.Normal)
                
                self.eventLocation = json["location"].stringValue
                
                var newLoc = self.eventLocation.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                
                var tmpArray1 : [String] = newLoc.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: "\n:,"))
                
                if tmpArray1.count > 3 {
                    newLoc = tmpArray1[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) + ", " + tmpArray1[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) + ", " + tmpArray1[2].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) + " " + tmpArray1[3].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                }
                
                self.btnEventLocation.setTitle(newLoc, forState: UIControlState.Normal)
                
                
                self.userID = json["created_by"].intValue
                
                DataManager.makeGetRequest("/api/users/\(self.userID)", completion: { (data, error) -> Void in
                    let userjson = JSON(data: data!)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.btnEventCreated.setTitle("Created by " + userjson["name"].stringValue, forState: UIControlState.Normal)
                        
                        if json["has_profile_pic"].stringValue == "true" {
                            DataManager.makeGetRequest("/api/s3get?event_id=\(self.userID)", completion: { (data, error) -> Void in
                                var picData = JSON(data: data!)
                                if picData["picture"] != nil {
                                    var base64String = json["picture"].stringValue
                                    let decodedString = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                                    var downloadedImage = UIImage(data: decodedString!)!
                                    self.userImage = Toucan(image: downloadedImage).resize(CGSizeMake(280, 140), fitMode: Toucan.Resize.FitMode.Scale).image
                                    
                                }
                            })
                        }

                    }
                })
                
                println("EventCreator:\t \(self.userID) \nUser:\t \(MusiciansWanted.userId)")
                if self.userID == MusiciansWanted.userId {
                    self.btnEdit.enabled = true
                }
                
            }
            
            if let presenter = self.controller {
                if presenter == "events" || presenter == "maps" {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.imgEvent.image = self.icon
                    }
                }
            }
            else {
                /*if json["has_profile_pic"].stringValue == "true" {
                    DataManager.makeGetRequest("/api/s3get?event_id=\(self.id)", completion: { (data, error) -> Void in
                        var picData = JSON(data: data!)
                        if picData["picture"] != nil {
                            var base64String = json["picture"].stringValue
                            let decodedString = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                            var downloadedImage = UIImage(data: decodedString!)!
                            var newImage = Toucan(image: downloadedImage).resize(CGSizeMake(280, 140), fitMode: Toucan.Resize.FitMode.Scale).image
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                //self.personIcon.image = newImage
                            }
                        }
                    })
                }
                else {*/
                    dispatch_async(dispatch_get_main_queue()) {
                        self.imgEvent.image = UIImage(named: "anonymous")
                    //}
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
    
    @IBAction func viewUser(sender: AnyObject) {
        
        let personView = self.storyboard?.instantiateViewControllerWithIdentifier("PersonViewController") as! PersonViewController
        
        personView.controller = "people"
        personView.icon = userImage
        personView.id = userID
                
        self.navigationController?.pushViewController(personView, animated: true)
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
