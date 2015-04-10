//
//  LogInViewController.swift
//  MusiciansWanted
//
//  Created by Joseph Canero on 3/25/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit
import CoreLocation

class LogInViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var ourLocation: String?
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
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
            var paramsDictionary = ["username": usernameField.text, "password": passwordField.text]
            DataManager.makePostRequest("/api/login", params: paramsDictionary, completion: { (data, error) -> Void in
                let json = JSON(data: data!)
                dispatch_async(dispatch_get_main_queue()) {
                    var alert:UIAlertController = UIAlertController()
                    var refreshToken: String? = json["refresh_token"].stringValue
                    if (refreshToken != "") {
                        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("GlobalTabBarController") as! GlobalTabBarController
                        
                        // set the data for the struct so that we can access it anywhere
                        MusiciansWanted.refreshToken = refreshToken!
                        MusiciansWanted.userId = json["user_id"].stringValue.toInt()!
                        self.setLocationTracking()
                        
                    }
                    else {
                        if json["errors"] == "There was a problem logging into soundcloud" {
                            SweetAlert().showAlert("Oops!", subTitle: "That email and password combination is incorrect.", style: AlertStyle.Error)
                        }
                        else {
                            SweetAlert().showAlert("Oops!", subTitle: "Please use your SoundCloud email address to log in.", style: AlertStyle.Error)
                        }
                    }
                }
            })
        }
    }
    
    // MARK: - Location Services
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(locationManager.location, completionHandler: { (placemarks, error) -> Void in
            if (error != nil) {
                println("Reverse geocoder failed with error " + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.useLocationInfo(pm)
            }
            else {
                println("Problem with the data received from the geocoder.")
            }
        })
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedWhenInUse:
            locationManager.startUpdatingLocation()
            MusiciansWanted.locationServicesDisabled = false
        case .NotDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .Restricted, .Denied, .AuthorizedAlways:
            setLocationString("")
            MusiciansWanted.locationServicesDisabled = true
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        setLocationString("")
        println("Error while updating location " + error.localizedDescription)
    }
    
    func useLocationInfo(placemark: CLPlacemark) {
        locationManager.stopUpdatingLocation()
        let subThoroughfare: String = (placemark.subThoroughfare != nil) ? placemark.subThoroughfare : ""
        let thoroughfare: String = (placemark.thoroughfare != nil) ? placemark.thoroughfare : ""
        var locationString = "\(subThoroughfare) \(thoroughfare) \(placemark.subLocality) "
        
        locationString = locationString.stringByAppendingString("\(placemark.locality) \(placemark.postalCode) \(placemark.country)")
        
        setLocationString(locationString)
    }
    
    func setLocationString(location: String) {
        ourLocation = location
    }
    
    func setLocationTracking() {
        let url = "/api/users/\(MusiciansWanted.userId)"
        let userParams = ["location": ourLocation!]
        let params = ["user": userParams]
        
        DataManager.makePatchRequest(url, params: params, completion: { (data, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("GlobalTabBarController") as! GlobalTabBarController
                self.presentViewController(viewController, animated: true, completion: nil)
            }
        })
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