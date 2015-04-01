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
    var bandBool: Bool = true
    var jamBool: Bool = true
    
    @IBOutlet weak var ageSlider: UISlider!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var jamSwitch: UISwitch!
    @IBOutlet weak var bandSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        ageSlider.value = ageValue
        ageLabel.text = ageText
        emailField.text = emailText
        nameField.text = nameText
        bandSwitch.setOn(bandBool, animated: false)
        jamSwitch.setOn(jamBool, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ageSliderChanged(sender: UISlider) {
        var sliderValue = Int(sender.value)
        ageLabel.text = "\(sliderValue)"
    }

    @IBAction func updateProfileButtonPress(sender: AnyObject) {
        if nameField.text == "" || emailField.text == "" {
            SweetAlert().showAlert("Uh oh!", subTitle: "Some required fields were left blank.", style: AlertStyle.Error)
            return
        }
        else {
            // submit the data to update the current user
            var url = "/api/users/\(MusiciansWanted.userId)"
            var params: Dictionary<String, AnyObject> = ["name": nameField.text, "email": emailField.text, "age": Int(ageSlider.value), "looking_to_jam": jamSwitch.on, "looking_for_band": bandSwitch.on]
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
                        SweetAlert().showAlert("Success!", subTitle: "Your profile has been updated.", style: AlertStyle.Success)
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

}
