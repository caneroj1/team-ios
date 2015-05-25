//
//  DataManager.swift
//  MusiciansWanted
//
//  Created by Dani Arnaout on 9/2/14.
//  Edited by Eric Cerney on 9/27/14.
//  Once again edited by Joe Canero on  3/28/15
//  Copyright (c) 2014 Ray Wenderlich All rights reserved.
//

import Foundation
import UIKit

//let mwURL = "http://45.56.101.202"
let mwURL = "http://localhost:3000"

let mwApiKey = NSProcessInfo.processInfo().environment["MW_KEY"] as! String

class DataManager {
    
    class func formatLocation(location: String) -> String {
        var locationString: String = location.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var tmpArray: [String] = locationString.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "\n:"))
        locationString = tmpArray[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) as String
        
        return locationString
    }
    
    class func makeSyncGetRequest(url: String) -> JSON {
        let request = NSURLRequest(URL: NSURL(string: mwURL + url)!)
        var response: NSURLResponse?
        var error: NSError?
        
        if let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error) {
            let json = JSON(data: data)
            return json
        }
        else {
            return nil
        }
    }
    
    class func makeGetRequest(url: String, completion:(data: NSData?, error: NSError?) -> Void) {
        var session = NSURLSession.sharedSession()
        
        // Use NSURLSession to get data from an NSURL
        let loadDataTask = session.dataTaskWithURL(NSURL(string: mwURL + url)!, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    var statusError = NSError(domain: "musicianswanted", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(data: nil, error: statusError)
                } else {
                    completion(data: data, error: nil)
                }
            }
        })
        
        loadDataTask.resume()
    }
    
    class func makePostRequest(url: String, params: Dictionary<String, AnyObject>, completion:(data: NSData?, error: NSError?) -> Void) {
        var request = NSMutableURLRequest(URL: NSURL(string: mwURL + url)!)
        var session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "POST"
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: .allZeros, error: nil)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(mwApiKey, forHTTPHeaderField: "mw-token")
        
        let loadDataTask = session.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if let responseError = error {
                println(error)
                completion(data: nil, error: responseError)
            } else if let requestResponse = response as? NSHTTPURLResponse {
                completion(data: data, error: nil)
            }
        })
        
        loadDataTask.resume()
    }
    
    class func makeDestroyRequest(url: String, completion:(data: NSData?, error: NSError?) -> Void) {
        var request = NSMutableURLRequest(URL: NSURL(string: mwURL + url)!)
        var session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "DELETE"
        //request.HTTPBody = NSJSONSerialization.dataWithJSONObject( options: .allZeros, error: nil)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(mwApiKey, forHTTPHeaderField: "mw-token")
        
        let loadDataTask = session.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if let responseError = error {
                println(error)
                completion(data: nil, error: responseError)
            } else if let requestResponse = response as? NSHTTPURLResponse {
                completion(data: data, error: nil)
            }
        })
        
        loadDataTask.resume()
    }
    
    class func uploadProfileImage(url: String, userID: Int, image: UIImage, completion:(data: NSData?, error: NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: mwURL + url)!)
        let session = NSURLSession.sharedSession()
        
        let data = UIImageJPEGRepresentation(image, 0.5)
        let encodedImage = data.base64EncodedStringWithOptions(.allZeros)
        
        let params = ["image": encodedImage, "user_id": userID]
        
        request.HTTPMethod = "POST"
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: .allZeros, error: nil)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(mwApiKey, forHTTPHeaderField: "mw-token")
        
        var error: NSError?
        
        if let error = error {
            println("\(error.localizedDescription)")
        }
        
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let requestResponse = response as? NSHTTPURLResponse {
                completion(data: data, error: nil)
            }
        })
        
        dataTask.resume()

    }
    
    class func uploadEventImage(url: String, eventID: Int, image: UIImage, completion:(data: NSData?, error: NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: mwURL + url)!)
        let session = NSURLSession.sharedSession()
        
        let data = UIImageJPEGRepresentation(image, 0.5)
        let encodedImage = data.base64EncodedStringWithOptions(.allZeros)
        
        let params = ["image": encodedImage, "event_id": eventID]
        
        request.HTTPMethod = "POST"
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: .allZeros, error: nil)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(mwApiKey, forHTTPHeaderField: "mw-token")
        
        var error: NSError?
        
        if let error = error {
            println("\(error.localizedDescription)")
        }
        
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let requestResponse = response as? NSHTTPURLResponse {
                completion(data: data, error: nil)
            }
        })
        
        dataTask.resume()
        
    }
    
    class func makePatchRequest(url: String, params: Dictionary<String, AnyObject>, completion:(data: NSData?, error: NSError?) -> Void) {
        var request = NSMutableURLRequest(URL: NSURL(string: mwURL + url)!)
        var session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "PATCH"
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: nil)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(mwApiKey, forHTTPHeaderField: "mw-token")
        
        let loadDataTask = session.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let requestResponse = response as? NSHTTPURLResponse {
                completion(data: data, error: nil)
            }
        })
        
        loadDataTask.resume()
    }
    
    class func checkForErrors(json: JSON) -> String {
        var errorString = ""
        if json["errors"] != nil {
            for (key, value) in json["errors"] {
                errorString += "\(transformKey(key)) "
                var errors:Array<String> = []
                var str = ", and "
                
                for error in value {
                    errors.append(transformError(error.1.stringValue))
                }
                
                errorString += "\(str.join(errors))\n\n"
            }
        }
        return errorString
    }
    
    private
    class func transformKey(key: String) -> String {
        var newKey = key.capitalizedString
        newKey = newKey.stringByReplacingOccurrencesOfString("_", withString: " ", options: NSStringCompareOptions.allZeros, range: Range<String.Index>(start: key.startIndex, end: key.endIndex))
        return newKey
    }
    
    class func transformError(error: String) -> String {
        return error.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}


