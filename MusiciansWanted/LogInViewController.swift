//
//  LogInViewController.swift
//  MusiciansWanted
//
//  Created by Joseph Canero on 3/25/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                        self.presentViewController(viewController, animated: true, completion: nil)
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
