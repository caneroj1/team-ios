//
//  FirstViewController.swift
//  MusiciansWanted
//
//  Created by Nick on 3/7/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class PeopleSettingViewController: UIViewController {
    
    @IBOutlet weak var contactsOnly: UISwitch!
    @IBOutlet weak var agesOption: UISwitch!
    @IBOutlet weak var jamOption: UISwitch!
    @IBOutlet weak var bandOption: UISwitch!
    
    @IBOutlet weak var lowerAgeTxt: UITextField!
    @IBOutlet weak var upperAgeTxt: UITextField!
    
    @IBOutlet weak var locationSettingBtn: UITableViewCell!
    @IBOutlet weak var genreSettingBtn: UITableViewCell!
    @IBOutlet weak var instrumentSettingBtn: UITableViewCell!
    
    var lowerAge:Int = 0
    var upperAge:Int = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationSettingBtn.textLabel?.text = "Location"
        locationSettingBtn.detailTextLabel?.text = "Ewing, NJ"
        genreSettingBtn.textLabel?.text = "Genre"
        genreSettingBtn.detailTextLabel?.text = "Any"
        instrumentSettingBtn.textLabel?.text = "Instrument"
        instrumentSettingBtn.detailTextLabel?.text = "Any"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            // what ever error code you need to write
            lowerAge = 0
        }
        
        if lowerAge < 0 {
            lowerAge = 0
        } else if lowerAge >= upperAge {
            lowerAge = upperAge - 1
        } else if lowerAge > 99 {
            lowerAge = 99
        }
        
        lowerAgeTxt.text = "\(lowerAge)"
    }
    
    
    @IBAction func upperAgeChanged(sender: UITextField) {
        
        if let upperNumber = NSNumberFormatter().numberFromString(upperAgeTxt.text) {
            upperAge = upperNumber.integerValue
        } else {
            // what ever error code you need to write
            upperAge = 100
        }
        
        if upperAge > 100 {
            upperAge = 100
        } else if upperAge <= lowerAge {
            upperAge = lowerAge + 1
        } else if upperAge < 1 {
            upperAge = 1
        }
        
        upperAgeTxt.text = "\(upperAge)"
    }
}