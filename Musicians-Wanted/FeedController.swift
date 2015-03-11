//
//  FeedController.swift
//  Musicians-Wanted
//
//  Created by Kari Gilbertson on 3/11/15.
//  Copyright (c) 2015 Kari Gilbertson. All rights reserved.
//

import UIKit

class FeedController: UIViewController {
    
    @IBOutlet weak var peopleButton: UIButton?
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: "feedView", bundle:nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func switchPeople(sender: UIButton) {
        let pc = PeopleController(nibName: "peopleView", bundle: nil)
        var navigationController = UINavigationController(rootViewController: pc)
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

