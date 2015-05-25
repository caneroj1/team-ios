//
//  GlobalTabBarController.swift
//  MusiciansWanted
//
//  Created by Nick on 3/12/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI

extension UIImage {
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext() as CGContextRef
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, kCGBlendModeNormal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        tintColor.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

class GlobalTabBarController: UITabBarController, CLLocationManagerDelegate {
    var refreshToken:String = ""
    var userID:Int = 0
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // you can add this code to you AppDelegate application:didFinishLaunchingWithOptions:
        // or add it to viewDidLoad method of your TabBarController class
        //let tabcolor1 = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        let navbarcolor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        let tabcolor1 = UIColor(red: 130.0/255.0, green: 130.0/255.0, blue: 135.0/255.0, alpha: 0.5)
        let tabcolor2 = UIColor(red: 255.0/255.0, green: 90.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        let tabbarcolor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 10.0/255.0, alpha: 1.0)
        
        UITabBar.appearance().barTintColor = tabbarcolor
        UITabBar.appearance().backgroundImage = UIImage(named: "bgBar")
        UINavigationBar.appearance().barTintColor = tabbarcolor
        
        
        let font = UIFont(name: "HelveticaNeue-Light", size: 20)
        if let font = font {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName : font, NSForegroundColorAttributeName : navbarcolor]//UIColor.whiteColor()]
        }
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: tabcolor1], forState:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: tabcolor2], forState:.Selected)
        
        
        self.tabBar.tintColor = tabcolor2
        
        for item in self.tabBar.items as! [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(tabcolor1).imageWithRenderingMode(.AlwaysOriginal)
            }
        }
        
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            setLocationTracking("")
            MusiciansWanted.locationServicesDisabled = true
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        setLocationTracking("")
        println("Error while updating location " + error.localizedDescription)
    }
    
    func useLocationInfo(placemark: CLPlacemark) {
        locationManager.stopUpdatingLocation()
        setLocationTracking(ABCreateStringWithAddressDictionary(placemark.addressDictionary, true))
    }
    
    func setLocationTracking(location: String) {
        let url = "/api/users/\(MusiciansWanted.userId)"
        let userParams = ["location": location]
        let params = ["user": userParams]
        
        DataManager.makePatchRequest(url, params: params, completion: { (data, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {

                // Get info from patch request
                let json = JSON(data: data!)
                
                // Get latitude and longitude as NSStrings
                let longitude: NSString = json["longitude"].stringValue
                let latitude: NSString = json["latitude"].stringValue
                
                // Store latitude and longitude as Doubles (type alias of CLLocationDegrees)
                MusiciansWanted.longitude = Double(longitude.floatValue)
                MusiciansWanted.latitude = Double(latitude.floatValue)
                
                // Store User information
                let defaults = NSUserDefaults.standardUserDefaults()
                
                defaults.setObject(MusiciansWanted.userId, forKey: "userId")
                defaults.setObject(MusiciansWanted.locationServicesDisabled, forKey: "locationServicesDisabled")
                defaults.setObject(MusiciansWanted.longitude, forKey: "longitude")
                defaults.setObject(MusiciansWanted.latitude, forKey: "latitude")
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