//
//  AddEventViewController.swift
//  MW
//
//  Created by hankharvey on 4/24/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

var thisSort = 4

class AddEventViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate,UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {
    
    var eventtitle: String = ""
    var hasEventPic: Bool = false
    var eventLocation: String = ""
    var eventdescription: String = ""
    var eventDate: String = ""
    var hasBeenSaved: Bool = false
    var eventID: Int = -1
    
    var states = [
        "Alabama", "Alaska", "American Samoa", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "District of Columbia", "Florida", "Georgia", "Guam", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Northern Marianas Islands", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Virgin Islands", "Washington", "West Virginia", "Wisconsin", "Wyoming"
    ]
    
    
    @IBOutlet var lblEvent: UILabel!
    @IBOutlet weak var EventTitle: UITextField!
    @IBOutlet weak var EventAddress: UITextField!
    @IBOutlet weak var EventCity: UITextField!
    @IBOutlet weak var StatePicker: UIPickerView!
    @IBOutlet weak var EventZip: UITextField!
    @IBOutlet weak var EventDescription: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var viewConstraint: NSLayoutConstraint!
    
    @IBAction func eventTitleChanged(sender: UITextField) {
        if EventTitle.text == "" {
            lblEvent.text = "New Event"
        }
        else {
            lblEvent.text = EventTitle.text.capitalizedString
        }
    }
    
    @IBAction func pressDelete(sender: UIButton) {
        
        SweetAlert().showAlert("Are you sure?", subTitle: "Your event will be deleted permanently!", style: AlertStyle.Warning, buttonTitle:"Cancel", buttonColor:UIColorFromRGB(0xD0D0D0) , otherButtonTitle:  "Yes, delete the event!", otherButtonColor: UIColorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
            if isOtherButton == true {
                
                return
            }
            else {
                
                var url = "/api/events/\(self.eventID)"
                
                DataManager.makeDestroyRequest(url, completion: { (data, error) -> Void in
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
                            SweetAlert().showAlert("Success!", subTitle: "Your event has been deleted.", style: AlertStyle.Success)
                            
                            //self.navigationController?.popViewControllerAnimated(true)
                            self.navigationController?.popToRootViewControllerAnimated(true)
                            
                            return
                        }
                    }
                })
            }
        }

    }
    
    @IBAction func touchZip(sender: UITextField) {
        scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.frame.size.height + 150
        //println("\(scrollView.contentOffset.y)")
    }
    
    @IBAction func realeaseZip(sender: UITextField) {
        scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.frame.size.height
        var date = formatDate(datePicker.date)
        //println("\(date)")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.frame.size.height + 200
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.frame.size.height;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardNotification:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        /*println("\(scrollView.contentSize.height)")
        println("\(scrollView.frame.size.height)")
        
        if scrollView.contentSize.height < scrollView.frame.size.height {
        scrollView.contentSize.height = scrollView.frame.size.height + 200
        }*/
        
        
        scrollView.canCancelContentTouches = false
        scrollView.delaysContentTouches = false
        StatePicker.delegate = self
        
        StatePicker.selectRow(thisSort, inComponent: 0, animated: true)
        
    }
    
    /*func keyboardWillShow(sender: NSNotification) {
    //self.view.frame.origin.y -= 150
    //scrollView.contentOffset.y += 150
    //scrollView.contentSize.height += 300
    //scrollView.frame.size.height
    
    }
    
    func keyboardWillHide(sender: NSNotification) {
    //self.view.frame.origin.y += 150
    //scrollView.contentOffset.y -= 150
    //scrollView.contentSize.height -= 300
    }*/
    
    override func viewWillAppear(animated: Bool) {
        btnDelete.hidden = true
        btnDelete.enabled = false
        
        if eventID >= 0 && eventtitle != "" {
            println("EventID: \(eventID)")
            self.title = "Update Event"
            viewConstraint.constant = 0
            btnDelete.hidden = false
            btnDelete.enabled = true
            lblEvent.text = eventtitle
            EventTitle.text = eventtitle
            EventDescription.text = eventdescription
            hasBeenSaved = true
            
            
            var url = "/api/s3EventGet?event_id=\(eventID)"
            
            DataManager.makeGetRequest(url, completion: { (data, error) -> Void in
                if data != nil {
                    var eventjson = JSON(data: data!)
                    if eventjson["picture"] != nil {
                        var base64String = eventjson["picture"].stringValue
                        
                        let decodedString = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                        var downloadedImage = UIImage(data: decodedString!)!
                        var newImage = Toucan(image: downloadedImage).resize(CGSizeMake(280, 140), fitMode: Toucan.Resize.FitMode.Scale).image
                        dispatch_async(dispatch_get_main_queue()) {
                            self.eventImage.image = newImage
                            
                        }
                            
                        
                    }
                }
                
            })
        

    
    
            //Format and display the location
            //[0] Address [1] City [2] State [3] Zip [4] Country
            var newLoc = eventLocation.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    
            var tmpArray1 : [String] = newLoc.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: "\n:,"))
            
            if tmpArray1.count > 3 {
                EventAddress.text = tmpArray1[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                EventCity.text = tmpArray1[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                EventZip.text = tmpArray1[3].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                var eventState = tmpArray1[2].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                
                for index in 0...states.count-1 {
                    if states[index] == eventState {
                        thisSort = index
                        break
                    }
                }
                StatePicker.selectRow(thisSort, inComponent: 0, animated: true)
            }
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "M/d/yy, h:mm a"
            let date = dateFormatter.dateFromString(eventDate)
            
            datePicker.setDate(date!, animated: true)
        }
        else if eventID >= 0 {
            self.title = "Update Event"
            viewConstraint.constant = 0
            btnDelete.hidden = false
            btnDelete.enabled = true
        }
        else {
            viewConstraint.constant = -185
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return states.count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView{
        
        
        var pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.blackColor()
        pickerLabel.text = states[row]
        // pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
        pickerLabel.font = UIFont(name: "Marker Felt", size: 24) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.Center
        
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        thisSort = row
    }
    
    @IBAction func eventCameraRoll(sender: AnyObject) {
        let eventImagePicker = UIImagePickerController()
        eventImagePicker.delegate = self
        
        if hasBeenSaved == false {
            SweetAlert().showAlert("Uh oh!", subTitle: "You must submit the picture when updating the event, not submitting.", style: AlertStyle.Error)
            return
        }
        self.presentViewController(eventImagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let eventPickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let newEventImage = Toucan(image: eventPickedImage).resizeByScaling(CGSizeMake(280, 140)).image as UIImage
        
        if hasBeenSaved == false {
            SweetAlert().showAlert("Uh oh!", subTitle: "You must submit the picture when updating the event, not submitting.", style: AlertStyle.Error)
            return
        }
        
        
        //left off working on putting event id in below
        DataManager.uploadEventImage("/api/s3EventPictureUpload",eventID: self.eventID, image: newEventImage, completion: { (data, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                SweetAlert().showAlert("Sweet!", subTitle: "Event picture successfully added!", style: AlertStyle.Success)
                self.eventImage.image = newEventImage
                return
            }
        })
        
        
    }
    
    func formatDate(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        let timeZone = NSTimeZone(abbreviation: "UTC");
        formatter.timeZone = timeZone
        
        //        let outputter = NSDateFormatter()
        //        outputter.dateStyle = NSDateFormatterStyle.ShortStyle
        //        outputter.timeStyle = NSDateFormatterStyle.ShortStyle
        //
        //        let offset = Double(formatter.timeZone.secondsFromGMT)
        return formatter.stringFromDate(date)
    }
    
    @IBAction func submitInfo(sender: UIBarButtonItem) {
        if EventTitle.text == "" || EventAddress.text == "" || EventCity.text == "" ||  EventZip.text == "" || EventDescription.text == "" {
            SweetAlert().showAlert("Uh oh!", subTitle: "Some required fields were left blank.", style: AlertStyle.Error)
            return
        }
        
        var location = EventAddress.text.capitalizedString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) + "\n" +  EventCity.text.capitalizedString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) + ", " + states[thisSort] + " : " + EventZip.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        var date = formatDate(datePicker.date)
        //println("\(date)")
        
        var eventParams: Dictionary<String, AnyObject> = ["title": EventTitle.text.capitalizedString, "location": location, "description": EventDescription.text, "event_time": date, "created_by": MusiciansWanted.userId]

        var params = ["event": eventParams]
        
        if eventID < 0 {
            
            var url = "/api/events"
            
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
                        SweetAlert().showAlert("Success!", subTitle: "Your event has been submitted.", style: AlertStyle.Success)
                        
                        self.eventID = json["id"].intValue
                        self.title = "Update Event"
                        self.viewConstraint.constant = 0
                        self.hasBeenSaved = true

                        //self.navigationController?.popViewControllerAnimated(true)
                        
                        return
                    }
                }
            })
        }
        else
        {
            var url = "/api/events/\(eventID)"
            //println(url)
            DataManager.makePatchRequest(url, params: params, completion: { (data, error) -> Void in
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
                        SweetAlert().showAlert("Success!", subTitle: "Your event has been updated.", style: AlertStyle.Success)
                        
                        self.navigationController?.popViewControllerAnimated(true)
                        
                        return
                    }
                }
            })
            
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


