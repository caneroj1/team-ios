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

let mwURL = "http://localhost:3000"

class DataManager {
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
        var apiKey = "9e0030ed1249f8db6f3352d0e0993549ab369f002ca78d0c2e0b167c831c9319519024db688cfa8af19f958c4b2183c04e88d2b7f96e062ca9b1886f6127ec1c"
        
        request.HTTPMethod = "POST"
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: nil)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(apiKey, forHTTPHeaderField: "mw-token")
        
        let loadDataTask = session.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let requestResponse = response as? NSHTTPURLResponse {
                completion(data: data, error: nil)
            }
        })
        
        loadDataTask.resume()
    }
}


