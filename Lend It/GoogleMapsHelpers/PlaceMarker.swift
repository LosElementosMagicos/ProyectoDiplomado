//
//  PlaceMarker.swift
//
//
//  Created by Daniel Esteban Salinas Suárez on 1/6/19.
//

import UIKit
import GoogleMaps
import CoreLocation

class PlaceMarker: GMSMarker {
  let place: Item
  
  init(place: Item) {
    self.place = place
    super.init()
    
    position = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
    icon = UIImage(named: "icon_item")
    groundAnchor = CGPoint(x: 0.5, y: 1)
    appearAnimation = .pop
  }
}
