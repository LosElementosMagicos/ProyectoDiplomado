//
//  User.swift
//  Lend It
//
//  Created by Daniel Esteban Salinas Suárez on 12/25/18.
//  Copyright © 2018 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit
import CoreLocation

struct Item {
    
    let ownerId: String
    let borrowingUserId: String
    let itemName: String
    let latitude: Double
    let longitude: Double
    let type: String
    let price: Int
    let itemPhoto1: String
    let itemPhoto2: String
    let itemPhoto3: String
    
    init(ownerId: String, borrowingUserId: String, itemName: String, latitude: Double, longitude: Double, type: String, price: Int, itemPhoto1: String, itemPhoto2: String, itemPhoto3: String) {
        self.ownerId = ownerId
        self.borrowingUserId = borrowingUserId
        self.itemName = itemName
        self.latitude = latitude
        self.longitude = longitude
        self.type = type
        self.price = price
        self.itemPhoto1 = itemPhoto1
        self.itemPhoto2 = itemPhoto2
        self.itemPhoto3 = itemPhoto3
    }
    
    // Func to conver model for easier writing to database
    func toAnyObject() -> Any {
        return [
            "itemName": itemName,
            "lat": latitude,
            "lon": longitude,
            "price": price,
            "type": type,
            "itemPhoto1": itemPhoto1,
            "itemPhoto2": itemPhoto2,
            "itemPhoto3": itemPhoto3,
            "ownerId": ownerId,
            "borrowingUserId": borrowingUserId
        ]
    }
    
}
