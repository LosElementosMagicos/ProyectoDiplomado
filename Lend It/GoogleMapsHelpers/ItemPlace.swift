//
//  itemPlace.swift
//  Lend It
//
//  Created by Daniel Esteban Salinas Suárez on 1/2/19.
//  Copyright © 2019 Daniel Esteban Salinas Suárez. All rights reserved.
//

import Foundation
import CoreLocation
import FirebaseDatabase


class ItemPlace {
    
    //let ref: DatabaseReference?
    let username: String
    let email: String
    let userID: String
    let title: String
    let location: CLLocationCoordinate2D
    let type: String
    let price: String
    
    init(dictionary: [String: Any], acceptedTypes: [String])
    {
        var items = [User]()
        let ref = Database.database().reference(withPath: "items")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            print("im in snapshot!")
            for child in snapshot.children {
                print("im a child!")
                guard let snapshot = child as? DataSnapshot else { continue }
                // Get user value
                let value = snapshot.value as? NSDictionary
                let userID = value?["userID"] as? String ?? ""
                let email = value?["email"] as? String ?? ""
                let lat = value?["lat"] as? String ?? ""
                let lon = value?["lon"] as? String ?? ""
                let price = value?["price"] as? String ?? ""
                let title = value?["title"] as? String ?? ""
                let type = value?["type"] as? String ?? ""
                let username = value?["username"] as? String ?? ""
                
                let latDegrees = Double(lat) as? CLLocationDegrees
                let lonDegrees = Double(lon) as? CLLocationDegrees
                
                self.email = email
                self.userID = userID
                self.price = price
                
                let user = User(username: username,
                                email: email,
                                userID: userID,
                                title: title,
                                lat: latDegrees,
                                lon: lonDegrees,
                                type: type,
                                price: price)
                
                items.append(user)
                self.nearbyPlaces = items
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}



