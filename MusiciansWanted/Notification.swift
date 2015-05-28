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
    let recordId: Int
    let notificationType: Int
    let id: Int
    
    init(title: String, date: String, location: String?, distance: String?, imageString: String, recordId: Int, notificationType: Int, id: Int) {
        self.title = title
        self.date = date
        self.location = location
        self.distance = distance
        self.imageString = imageString
        self.recordId = recordId
        self.notificationType = notificationType
        self.id = id
    }
}
