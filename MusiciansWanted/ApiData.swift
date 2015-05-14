//
//  ApiData.swift
//  MusiciansWanted
//
//  Created by Joseph Canero on 3/29/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import Foundation
import CoreLocation

struct MusiciansWanted {
    static var userId: Int = 0
    static var refreshToken = ""
    static var locationServicesDisabled: Bool?
    static var longitude: CLLocationDegrees?
    static var latitude: CLLocationDegrees?
    //static var filters = [String:Bool]()
}