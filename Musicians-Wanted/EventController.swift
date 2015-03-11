//
//  EventController.swift
//  Musicians-Wanted
//
//  Created by Kari Gilbertson on 3/11/15.
//  Copyright (c) 2015 Kari Gilbertson. All rights reserved.
//

import Foundation
import UIKit

class EventController: UIViewController {
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: "eventView", bundle:nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

