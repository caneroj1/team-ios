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
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.location = locationName
        self.coordinate = coordinate

        super.init()
    }
}