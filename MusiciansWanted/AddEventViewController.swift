//
//  AddEventViewController.swift
//  MW
//
//  Created by hankharvey on 4/24/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

var thisSort = 4

class AddEventViewController: UIViewController, UIPickerViewDelegate {
    
    var eventtitle: String = ""
    var address: String = ""
    var city: String = ""
    var eventStateRow: Int = 0
    var zip: Int = 0
    var eventdescription: String = ""
    
    var states = [
        "Alabama", "Alaska", "American Samoa", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "District of Columbia", "Florida", "Georgia", "Guam", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Northern Marianas Islands", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Virgin Islands", "Washington", "West Virginia", "Wisconsin", "Wyoming"
    ]
    
    
    @IBOutlet weak var EventTitle: UITextField!
    @IBOutlet weak var EventAddress: UITextField!
    @IBOutlet weak var EventCity: UITextField!    
    @IBOutlet weak var StatePicker: UIPickerView!
    @IBOutlet weak var EventZip: UITextField!
    @IBOutlet weak var EventDescription: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        scrollView.canCancelContentTouches = false
        scrollView.delaysContentTouches = false
        StatePicker.delegate = self
        
        StatePicker.selectRow(thisSort, inComponent: 0, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        EventTitle.text = eventtitle
        EventAddress.text = address
        EventCity.text = city
        thisSort = eventStateRow
        EventZip.text = String(zip)
        EventDescription.text = description
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
    
    @IBAction func submitInfo(sender: UIBarButtonItem) {
        if EventTitle.text == "" || EventAddress.text == "" || EventCity.text == "" ||  EventZip.text == "" || EventDescription.text == "" {
            SweetAlert().showAlert("Uh oh!", subTitle: "Some required fields were left blank.", style: AlertStyle.Error)
            return
        }
            var url = "/api/events/"
            var eventParams: Dictionary<String, AnyObject> = ["title": EventTitle.text, "address": EventAddress.text, "city": EventCity.text, "zip": EventZip.text, "description": EventDescription.text!]
            var params = ["user": eventParams]
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
                        SweetAlert().showAlert("Success!", subTitle: "Your event has been submitted.", style: AlertStyle.Success)
                        return
                    }
                }
            })
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


