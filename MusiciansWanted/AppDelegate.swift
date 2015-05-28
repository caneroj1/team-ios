//
//  AppDelegate.swift
//  MusiciansWanted
//
//  Created by Nick on 3/7/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit
import WatchKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //AWSLogger.defaultLogger().logLevel = AWSLogLevel.Verbose
        
        
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType: CognitoRegionType,
            identityPoolId: CognitoIdentityPoolId
            )
        let configuration = AWSServiceConfiguration(
            region: DefaultServiceRegionType,
            credentialsProvider: credentialsProvider)
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
        
        // Determine if user logged in:
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if (defaults.objectForKey("userId") != nil) {
            MusiciansWanted.userId = defaults.integerForKey("userId")
            MusiciansWanted.locationServicesDisabled = defaults.boolForKey("locationServicesDisabled")
            MusiciansWanted.longitude = defaults.objectForKey("longitude") as? CLLocationDegrees
            MusiciansWanted.latitude = defaults.objectForKey("latitude") as? CLLocationDegrees

            
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            var initialViewController = storyboard.instantiateViewControllerWithIdentifier("GlobalTabBarController") as! GlobalTabBarController
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }

        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {
        
        if let find = userInfo?["find"] as? String {
            if find == "events" {
                reply(fetchEvents())
                return
            }
            else if find == "people" {
                reply(fetchPeople())
                return
            }
        }
        
        reply(["mw":"bad_reply"])
        return
    }
    
    func fetchPeople() -> [NSObject: AnyObject] {
        var url = "/api"
        var results = [NSObject: AnyObject]()
        
        if let id = NSUserDefaults.standardUserDefaults().objectForKey("userId") as? Int {
            url += "/users/\(id)/near_me"
        }
        else {
            url += "/users"
        }
        
        var peopleArray = populatePeople(DataManager.makeSyncGetRequest(url))
        
        if peopleArray.count != 0 {
            results.updateValue(peopleArray, forKey: "results")
        }
        else {
            results.updateValue("There are no nearby people", forKey: "error")
        }
        
        return results
    }
    
    func fetchEvents() -> [NSObject: AnyObject] {
        var url = "/api"
        var results = [NSObject: AnyObject]()
        
        if let id = NSUserDefaults.standardUserDefaults().objectForKey("userId") as? Int {
            url += "/users/\(id)/events_near_me"
        }
        else {
            url += "/events"
        }
        
        var eventArray = populateEvents(DataManager.makeSyncGetRequest(url))
        
        if eventArray.count != 0 {
            results.updateValue(eventArray, forKey: "results")
        }
        else {
            results.updateValue("There are no nearby events.", forKey: "error")
        }
        
        return results
    }
    
    func populateEvents(data: JSON) -> [String] {
        var eventArray = [String]()
        for item in data {
            var str = ""
            str += (item.1["title"].stringValue)
            str += ("|" + item.1["event_time"].stringValue)
            str += ("|" + item.1["location"].stringValue)
            eventArray.append(str)
        }
        
        return eventArray
    }
    
    func populatePeople(data: JSON) -> [String] {
        var peopleArray = [String]()
        for item in data {
            var str = ""
            str += (item.1["name"].stringValue)
            str += ("|" + item.1["location"].stringValue)
            peopleArray.append(str)
        }
        
        return peopleArray
    }
}

