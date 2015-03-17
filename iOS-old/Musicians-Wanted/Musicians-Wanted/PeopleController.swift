//
//  PeopleController.swift
//  Musicians-Wanted
//
//  Created by Kari Gilbertson on 3/11/15.
//  Copyright (c) 2015 Kari Gilbertson. All rights reserved.
//

import Foundation
import UIKit

class PeopleController: UIViewController {
    
    @IBOutlet weak var feedButton: UIBarButtonItem?
    @IBOutlet weak var peopleButton: UIBarButtonItem?
    @IBOutlet weak var eventButton: UIBarButtonItem?
    @IBOutlet weak var groupButton: UIBarButtonItem?
    @IBOutlet weak var messageButton: UIBarButtonItem?
    @IBOutlet weak var profileButton: UIBarButtonItem?
    @IBOutlet weak var setttingsButton: UIBarButtonItem?
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: "peopleView", bundle:nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func switchFeed(feedButton: UIBarButtonItem) {
        let fc = FeedController(nibName: "feedView", bundle: nil)
        var navigationController = UINavigationController(rootViewController: fc)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    @IBAction func switchPeople(peopleButton: UIBarButtonItem) {
        let pc = PeopleController(nibName: "feedView", bundle: nil)
        var navigationController = UINavigationController(rootViewController: pc)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    @IBAction func switchEvent(eventButton: UIBarButtonItem) {
        let ec = EventController(nibName: "eventView", bundle: nil)
        var navigationController = UINavigationController(rootViewController: ec)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    @IBAction func switchGroup(groupButton: UIBarButtonItem) {
        let gc = GroupController(nibName: "groupView", bundle: nil)
        var navigationController = UINavigationController(rootViewController: gc)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    @IBAction func switchMessage(messageButton: UIBarButtonItem) {
        let mc = MessageController(nibName: "messageView", bundle: nil)
        var navigationController = UINavigationController(rootViewController: mc)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    @IBAction func switchProfile(profileButton: UIBarButtonItem) {
        let pc = ProfileController(nibName: "profileView", bundle: nil)
        var navigationController = UINavigationController(rootViewController: pc)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    @IBAction func switchSettings(settingsButton: UIBarButtonItem) {
        let sc = SettingsController(nibName: "settingsView", bundle: nil)
        var navigationController = UINavigationController(rootViewController: sc)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

