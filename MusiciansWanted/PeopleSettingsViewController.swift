//
//  FirstViewController.swift
//  MusiciansWanted
//
//  Created by Nick on 3/7/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class PeopleSettingViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var contactsOnly: UISwitch!
    @IBOutlet var agesOption: UISwitch!
    @IBOutlet var jamOption: UISwitch!
    @IBOutlet var bandOption: UISwitch!
    
    @IBOutlet var lowerAgeTxt: UITextField!
    @IBOutlet var upperAgeTxt: UITextField!
    
    var lowerAge:Int = 13;
    var upperAge:Int = 75;
    
    //Check Filters
    override func viewWillAppear(animated: Bool) {
        contactsOnly.on = Filters.contactsOnly
        agesOption.on = Filters.ageOn
        jamOption.on = Filters.looking_to_jam
        bandOption.on = Filters.looking_for_band
        upperAge = Filters.upperAge
        lowerAge = Filters.lowerAge
        lowerAgeTxt.text = "\(Filters.lowerAge)"
        upperAgeTxt.text = "\(Filters.upperAge)"
        
        if agesOption.on {
            lowerAgeTxt.enabled = true
            lowerAgeTxt.backgroundColor = UIColor.whiteColor()
            upperAgeTxt.enabled = true
            upperAgeTxt.backgroundColor = UIColor.whiteColor()
        }
        else {
            lowerAgeTxt.enabled = false
            lowerAgeTxt.backgroundColor = UIColor.lightGrayColor()
            upperAgeTxt.enabled = false
            upperAgeTxt.backgroundColor = UIColor.lightGrayColor()
        }
        
        println(Filters.upperAge)
        
        println("dat update.")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    @IBAction func contactsOnlyStateChanged(sender: UISwitch) {
        //Contacts Only Switch
        if contactsOnly.on {
            Filters.contactsOnly = true
        }
        else {
            Filters.contactsOnly = false
        }
    }
    
    @IBAction func ageStateChanged(sender: AnyObject) {
        
        if agesOption.on {
            lowerAgeTxt.enabled = true
            lowerAgeTxt.backgroundColor = UIColor.whiteColor()
            upperAgeTxt.enabled = true
            upperAgeTxt.backgroundColor = UIColor.whiteColor()
            lowerAge = lowerAgeTxt.text.toInt()!
            upperAge = upperAgeTxt.text.toInt()!
            Filters.ageOn = true
        } else {
            lowerAgeTxt.enabled = false
            lowerAgeTxt.backgroundColor = UIColor.lightGrayColor()
            upperAgeTxt.enabled = false
            upperAgeTxt.backgroundColor = UIColor.lightGrayColor()
            lowerAge = 13
            upperAge = 75
            Filters.ageOn = false
        }
        Filters.lowerAge = lowerAge
        Filters.upperAge = upperAge
    }
    
    @IBAction func jamStateChanged(sender: UISwitch) {
        //Look to Jam Switch
        if jamOption.on {
            Filters.looking_to_jam = true
        }
        else {
            Filters.looking_to_jam = false
        }
    }
    
    @IBAction func bandStateChanged(sender: UISwitch) {
        //Looking for Band Switch
        if bandOption.on {
            Filters.looking_for_band = true
        }
        else {
            Filters.looking_for_band = false
        }
    }
    
    @IBAction func lowerAgeChanged(sender: UITextField) {
        
        if let lowerNumber = NSNumberFormatter().numberFromString(lowerAgeTxt.text) {
            lowerAge = lowerNumber.integerValue
        } else {
            lowerAge = 13
        }
        
        if lowerAge < 13 {
            lowerAge = 13
        } else if lowerAge >= upperAge {
            lowerAge = upperAge - 1
        } else if lowerAge > 74 {
            lowerAge = 74
        }
        
        lowerAgeTxt.text = "\(lowerAge)"
        Filters.lowerAge = lowerAge
        Filters.upperAge = upperAge
    }
    
    
    @IBAction func upperAgeChanged(sender: UITextField) {
        
        if let upperNumber = NSNumberFormatter().numberFromString(upperAgeTxt.text) {
            upperAge = upperNumber.integerValue
        } else {
            upperAge = 75
        }
        
        if upperAge > 75 {
            upperAge = 75
        } else if upperAge <= lowerAge {
            upperAge = lowerAge + 1
        } else if upperAge < 14 {
            upperAge = 14
        }
        
        upperAgeTxt.text = "\(upperAge)"
        Filters.lowerAge = lowerAge
        Filters.upperAge = upperAge
    }
}