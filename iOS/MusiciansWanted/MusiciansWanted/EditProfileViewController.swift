//
//  EditProfileViewController.swift
//  MusiciansWanted
//
//  Created by Joseph Canero on 3/29/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    var ageText: String = ""
    var emailText: String = ""
    var nameText: String = ""
    var ageValue: Float = 0
    var locationBool: Bool = true
    
    @IBOutlet weak var ageSlider: UISlider!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var locationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        ageSlider.value = ageValue
        ageLabel.text = ageText
        emailField.text = emailText
        nameField.text = nameText
        locationSwitch.setOn(locationBool, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ageSliderChanged(sender: UISlider) {
        var sliderValue = Int(sender.value)
        ageLabel.text = "\(sliderValue)"
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
