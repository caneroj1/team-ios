//
//  LogInViewController.swift
//  MusiciansWanted
//
//  Created by Joseph Canero on 3/25/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI

class LogInViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    let locationManager = CLLocationManager()
    var ourLocation: String?
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // start up location services
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedWhenInUse:
            locationManager.startUpdatingLocation()
            MusiciansWanted.locationServicesDisabled = false
        case .NotDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .Restricted, .Denied, .AuthorizedAlways:
            MusiciansWanted.locationServicesDisabled = true
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInAction(sender: AnyObject!) {
        if(usernameField.text != "" && passwordField.text != "") {
            var paramsDictionary = ["email": usernameField.text.lowercaseString, "password": passwordField.text]
            DataManager.makePostRequest("/api/login", params: paramsDictionary, completion: { (data, error) -> Void in
                let json = JSON(data: data!)
                dispatch_async(dispatch_get_main_queue()) {
                    var alert:UIAlertController = UIAlertController()
                    var userId: String? = json["user_id"].stringValue
                    if (userId != "") {
                        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("GlobalTabBarController") as! GlobalTabBarController
                        self.presentViewController(viewController, animated: true, completion: nil)
                        // set the data for the struct so that we can access it anywhere
                        MusiciansWanted.userId = userId!.toInt()!
                        
                    }
                    else {
                        if json["errors"] == "There was a problem logging into soundcloud" {
                            SweetAlert().showAlert("Oops!", subTitle: "That email and password combination is incorrect.", style: AlertStyle.Error)
                        }
                        else {
                            SweetAlert().showAlert("Oops!", subTitle: "Something went wrong.", style: AlertStyle.Error)
                        }
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