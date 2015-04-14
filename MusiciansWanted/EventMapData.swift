//
//  EventMapData.swift
//  MW
//
//  Created by Joseph Canero on 4/13/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import Foundation
import MapKit

class Event: NSObject, MKAnnotation {
    let title: String
    let location: String
    let coordinate: CLLocationCoordinate2D
    let id: Int
    let icon: UIImage
    
    init(title: String, locationName: String, id: Int, icon: UIImage, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.location = locationName
        self.coordinate = coordinate
        self.id = id
        self.icon = icon
        
        super.init()
    }
}