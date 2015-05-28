//
//  NewMessageViewController.swift
//  MW
//
//  Created by Nick on 5/21/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

struct toContact {
    var name = ""
    var id = -1
    var cellSize = CGSize(width: 100, height: 20)
}

class NewMessageViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet var contactCollection: UICollectionView!
    @IBOutlet var subjectText: UITextField!
    @IBOutlet var bodyText: UITextView!
    @IBOutlet var sendButton: UIButton!
    
    var toContacts = [toContact]()
    
    @IBAction func sendMessage(sender: UIButton) {
        
        if subjectText.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "" || bodyText.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "" || toContacts.count < 1 {
            SweetAlert().showAlert("Uh oh!", subTitle: "Some required fields were left blank.", style: AlertStyle.Error)
        }
        else {
            
            var url = "/api/messages"
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
            
            let offset = Double(formatter.timeZone.secondsFromGMT)
            let strdate = formatter.stringFromDate(NSDate().dateByAddingTimeInterval(offset))
            
            var messageParams: Dictionary<String, AnyObject> = ["subject": subjectText.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()), "body": bodyText.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()), "created_at": strdate, "updated_at": strdate, "sent_by": MusiciansWanted.userId, "user_id": toContacts[0].id, "seen_by_sender": true, "seen_by_receiver": false]
            
            /*{
            "id" : 35,
            "created_at" : "2015-05-17T17:39:53.236Z",
            "subject" : "Exclusive national toolset",
            "user_id" : 112,
            "updated_at" : "2015-05-17T17:39:53.236Z",
            "body" : "Laboriosam earum incidunt soluta amet aut et qui.",
            "sent_by" : 116
            }*/
            
            var params = ["message": messageParams]
            
            DataManager.makePostRequest(url, params: params, completion: { (data, error) -> Void in
                var json = JSON(data: data!)
                var errorString = DataManager.checkForErrors(json)
                if errorString != "" {
                    dispatch_async(dispatch_get_main_queue()) {
                        SweetAlert().showAlert("Oops!", subTitle: errorString, style: AlertStyle.Error)
                        return
                    }
                }
                else {
                    dispatch_async(dispatch_get_main_queue()) {
                        SweetAlert().showAlert("Success!", subTitle: "Your message has been sent.", style: AlertStyle.Success)
                        
                        var message_id = json["id"].intValue
                        var newurl: String = "/api/messages/\(message_id)/replies"
                        
                        var replyParams: Dictionary<String, AnyObject> = ["id": message_id, "body": self.bodyText.text, "user_id": MusiciansWanted.userId]
                 
                        var newparams = ["reply": replyParams]
                        
                        DataManager.makePostRequest(newurl, params: newparams, completion: { (data, error) -> Void in
                            var json = JSON(data: data!)
                            var errorString = DataManager.checkForErrors(json)
                            
                            if errorString != "" {
                                dispatch_async(dispatch_get_main_queue()) {
                                    SweetAlert().showAlert("Oops!", subTitle: errorString, style: AlertStyle.Error)
                                    return
                                }
                            }
                        })

                        
                        self.navigationController?.popToRootViewControllerAnimated(true)
                        
                        return
                    }
                }
            })
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let lightestGrayColor: UIColor = UIColor( red: 200.0/255.0, green: 200.0/255.0, blue:200.0/255.0, alpha: 1.0 )
        
        self.bodyText.layer.borderColor = lightestGrayColor.CGColor
        self.bodyText.layer.borderWidth = 0.6
        self.bodyText.layer.cornerRadius = 5.0
        self.bodyText.clipsToBounds = true
        self.bodyText.layer.masksToBounds = true
        
        contactCollection.reloadData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        contactCollection.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{

        return toContacts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell: ToContactCell = collectionView.dequeueReusableCellWithReuseIdentifier("toContactCell", forIndexPath: indexPath) as! ToContactCell
        
        cell.contactName.text = toContacts[indexPath.row].name
        
        let textViewFixedHeight = cell.contactName.frame.size.height
        toContacts[indexPath.row].cellSize = cell.contactName.sizeThatFits(CGSizeMake(CGFloat(MAXFLOAT), textViewFixedHeight))
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: toContacts[indexPath.row].cellSize.width + 20, height: 22)
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //toContacts.removeAtIndex(indexPath.row)
        //contactCollection.reloadData()
        self.navigationController?.popViewControllerAnimated(true)

    }
}
