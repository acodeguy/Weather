//
//  ChangeLocationDelegate.swift
//  Weather
//
//  Created by Andrew. on 25/09/2018.
//  Copyright © 2018 A Code Guy. All rights reserved.
//

import Foundation

protocol ChangeLocationDelegate {
    
    func newLocationEntered(lat: String, lon: String)
}
