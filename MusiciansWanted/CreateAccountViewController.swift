//
//  CreateAccountViewController.swift
//  MW
//
//  Created by Joseph Canero on 5/25/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit
import CoreLocation

class CreateAccountViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var location: String?
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userPasswordConfirmation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // start up location services
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedWhenInUse:
            println("gonna update location")
            locationManager.startUpdatingLocation()
            MusiciansWanted.locationServicesDisabled = false
        case .NotDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .Restricted, .Denied, .AuthorizedAlways:
            location = ""
            MusiciansWanted.locationServicesDisabled = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccountAction(sender: UIButton) {
        let userParams = ["name": userName.text, "email": userEmail.text, "password": userPassword.text, "password_confirmation": userPasswordConfirmation.text, "location": location!]
        let params = ["user": userParams]
        
        DataManager.makePostRequest("/api/users", params: params, completion: { (data, error) -> Void in
            let json = JSON(data: data!)
            
            let errors = DataManager.checkForErrors(json)
            if errors != "" {
                dispatch_async(dispatch_get_main_queue()) {
                    SweetAlert().showAlert("Uh oh!", subTitle: errors, style: AlertStyle.Error)
                    return
                }
            }
            else {
                let userId = json["id"].stringValue
                if userId != "" {
                    dispatch_async(dispatch_get_main_queue()) {
                        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("GlobalTabBarController") as! GlobalTabBarController
                        self.presentViewController(viewController, animated: true, completion: nil)
                        MusiciansWanted.userId = userId.toInt()!
                    }
                }
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
    
    // MARK: - Location Services
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(locationManager.location, completionHandler: { (placemarks, error) -> Void in
            println("GOT LOCATIONNNNNN")
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
            location = ""
            MusiciansWanted.locationServicesDisabled = true
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        location = ""
        println("Error while updating location " + error.localizedDescription)
    }
    
    func useLocationInfo(placemark: CLPlacemark) {
        locationManager.stopUpdatingLocation()
        let subThoroughfare: String = (placemark.subThoroughfare != nil) ? placemark.subThoroughfare : ""
        let thoroughfare: String = (placemark.thoroughfare != nil) ? placemark.thoroughfare : ""
        var locationString = "\(subThoroughfare) \(thoroughfare)\n\(placemark.subLocality), "
        
        var locality = placemark.locality
        
        switch placemark.locality.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) {
        case "alabama":
            locality = "AL"
        case "alaska":
            locality = "AK"
        case "arizona":
            locality = "AZ"
        case "arkinsas":
            locality = "AR"
        case "california":
            locality = "CA"
        case "colorado":
            locality = "CO"
        case "connecticut":
            locality = "CT"
        case "delaware":
            locality = "DE"
        case "florida":
            locality = "FL"
        case "georgia":
            locality = "GA"
        case "hawaii":
            locality = "HI"
        case "idaho":
            locality = "ID"
        case "illinois":
            locality = "IL"
        case "indiana":
            locality = "IN"
        case "iowa":
            locality = "IA"
        case "kansas":
            locality = "KS"
        case "kentucky":
            locality = "KY"
        case "louisiana":
            locality = "LA"
        case "maine":
            locality = "ME"
        case "maryland":
            locality = "MD"
        case "massachusetts":
            locality = "MA"
        case "michigan":
            locality = "MI"
        case "minnesota":
            locality = "MN"
        case "missouri":
            locality = "MO"
        case "montana":
            locality = "MT"
        case "nebraska":
            locality = "NE"
        case "nevada":
            locality = "NV"
        case "new hampshire":
            locality = "NH"
        case "new jersey":
            locality = "NJ"
        case "new mexico":
            locality = "NM"
        case "new york":
            locality = "NY"
        case "north carolina":
            locality = "NC"
        case "north dakota":
            locality = "ND"
        case "ohio":
            locality = "OH"
        case "oklahoma":
            locality = "OK"
        case "oregon":
            locality = "OR"
        case "pennsylvania":
            locality = "PA"
        case "rhode island":
            locality = "RI"
        case "south carolina":
            locality = "SC"
        case "south dakota":
            locality = "SD"
        case "tennessee":
            locality = "TN"
        case "texas":
            locality = "TX"
        case "utah":
            locality = "UT"
        case "vermont":
            locality = "VT"
        case "virginia":
            locality = "VA"
        case "washington":
            locality = "WA"
        case "west virginia":
            locality = "WV"
        case "wisconsin":
            locality = "WI"
        case "wyoming":
            locality = "WY"
        default:
            locality = placemark.locality
        }
        
        locationString = locationString.stringByAppendingString("\(locality) : \(placemark.postalCode)\n\(placemark.country)")
        
        println("IT IS \(locationString)")
        location = locationString
    }
}
