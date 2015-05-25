//
//  FeedSettingsViewController.swift
//  MusiciansWanted
//
//  Created by Nick on 3/12/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit


class FeedSettingsViewController: UITableViewController, UIPickerViewDelegate {

    var sortBy = ["Everyone","My Contacts","Only Me"]
    var selectedSort = NSUserDefaults.standardUserDefaults().objectForKey("selectedSort") == nil ? 1 : NSUserDefaults.standardUserDefaults().integerForKey("selectedSort")

    @IBOutlet weak var sortPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        sortPicker.selectRow(selectedSort, inComponent: 0, animated: true)
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
        return sortBy.count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView{
        
        var pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.blackColor()
        pickerLabel.text = sortBy[row]
        // pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
        pickerLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 20)
        pickerLabel.textAlignment = NSTextAlignment.Center
        
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        selectedSort = row
        NSUserDefaults.standardUserDefaults().setObject(selectedSort, forKey: "selectedSort")
    }
}
