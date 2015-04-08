//
//  EditProfileViewController.swift
//  MusiciansWanted
//
//  Created by Joseph Canero on 3/29/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITextFieldDelegate {
    var ageText: String = ""
    var emailText: String = ""
    var nameText: String = ""
    var ageValue: Float = 0
    var bandBool: Bool = true
    var jamBool: Bool = true
    var radiusValue: Float = 0
    var radiusLabel: String = ""
    var gender: String = ""
    
    @IBOutlet weak var ageSlider: UISlider!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var jamSwitch: UISwitch!
    @IBOutlet weak var bandSwitch: UISwitch!
    @IBOutlet weak var locationRadiusSlider: UISlider!
    @IBOutlet weak var locationRadiusLabel: UILabel!
    @IBOutlet weak var genderControl: UISegmentedControl!
    
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
        locationRadiusSlider.value = radiusValue
        locationRadiusLabel.text = radiusLabel
        
        println(gender)
        
        if gender != "none" {
            var genderIndex = (gender == "male") ? 0 : 1
            genderControl.selectedSegmentIndex = genderIndex

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    @IBAction func ageSliderChanged(sender: UISlider) {
        let sliderValue = Int(sender.value)
        ageLabel.text = "\(sliderValue)"
    }

    @IBAction func locationRadiusSliderChanged(sender: UISlider) {
        let sliderValue = Int(sender.value)
        locationRadiusLabel.text = "\(sliderValue) miles"
    }
    
    @IBAction func updateProfileButtonPress(sender: UIBarButtonItem) {
        if nameField.text == "" || emailField.text == "" {
            SweetAlert().showAlert("Uh oh!", subTitle: "Some required fields were left blank.", style: AlertStyle.Error)
            return
        }
        else {
            // submit the data to update the current user
            var gender: String?
            
            switch genderControl.selectedSegmentIndex {
                case 0:
                    gender = "male"
                    
                case 1:
                    gender = "female"
                    
                default:
                    gender = ""
            }
            
            var url = "/api/users/\(MusiciansWanted.userId)"
            var userParams: Dictionary<String, AnyObject> = ["name": nameField.text, "email": emailField.text, "age": Int(ageSlider.value), "looking_to_jam": jamSwitch.on, "looking_for_band": bandSwitch.on, "search_radius": Int(locationRadiusSlider.value), "gender": gender!]
            var params = ["user": userParams]
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//    }
    

}
