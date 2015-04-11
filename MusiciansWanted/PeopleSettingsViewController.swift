//
//  FirstViewController.swift
//  MusiciansWanted
//
//  Created by Nick on 3/7/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class PeopleSettingViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var contactsOnly: UISwitch!
    @IBOutlet weak var agesOption: UISwitch!
    @IBOutlet weak var jamOption: UISwitch!
    @IBOutlet weak var bandOption: UISwitch!
    
    @IBOutlet weak var lowerAgeTxt: UITextField!
    @IBOutlet weak var upperAgeTxt: UITextField!
    
    var lowerAge:Int = 13;
    var upperAge:Int = 75;
    
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
    }
    
    @IBAction func ageStateChanged(sender: AnyObject) {
        
        if agesOption.on {
            lowerAgeTxt.enabled = true
            lowerAgeTxt.backgroundColor = UIColor.whiteColor()
            upperAgeTxt.enabled = true
            upperAgeTxt.backgroundColor = UIColor.whiteColor()
            lowerAge = lowerAgeTxt.text.toInt()!
            upperAge = upperAgeTxt.text.toInt()!
        } else {
            lowerAgeTxt.enabled = false
            lowerAgeTxt.backgroundColor = UIColor.lightGrayColor()
            upperAgeTxt.enabled = false
            upperAgeTxt.backgroundColor = UIColor.lightGrayColor()
            lowerAge = 0
            upperAge = 100
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
    }
}