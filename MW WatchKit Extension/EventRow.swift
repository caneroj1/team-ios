//
//  EventRowController.swift
//  MW
//
//  Created by Joseph Canero on 5/20/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import Foundation
import WatchKit

class EventRow: NSObject {
    
    @IBOutlet weak var eventTitle: WKInterfaceLabel!
    @IBOutlet weak var eventLocation: WKInterfaceLabel!
    @IBOutlet weak var eventDate: WKInterfaceLabel!
}