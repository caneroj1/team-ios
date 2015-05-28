//
//  FeedViewDelegate.swift
//  MW
//
//  Created by Joseph Canero on 4/9/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import Foundation

protocol FeedViewDelegate {
    func addedNewItem()
    func appliedFilters()
    func stopRefreshing()
}