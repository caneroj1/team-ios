//
//  Notification.swift
//  MW
//
//  Created by Joseph Canero on 4/9/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import Foundation

class Notification {
    let title: String
    let location: String?
    let distance: String?
    let date: String
    let imageString: String
    
    init(title: String, date: String, location: String?, distance: String?, imageString: String) {
        self.title = title
        self.date = date
        self.location = location
        self.distance = distance
        self.imageString = imageString
    }
}
