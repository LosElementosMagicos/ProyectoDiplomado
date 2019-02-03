//
//  Lend_ItTests.swift
//  Lend ItTests
//
//  Created by Daniel Esteban Salinas Suárez on 12/24/18.
//  Copyright © 2018 Daniel Esteban Salinas Suárez. All rights reserved.
//

import XCTest
@testable import Lend_It

class Lend_ItTests: XCTestCase {
    
    var mapView: MapViewController!

    override func setUp() {
        super.setUp()
        let mapStoryboard = UIStoryboard(name: "Main", bundle: nil)
        mapView = mapStoryboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController
        mapView.loadView() // This line is the key

    }

    func testMapViewStartsHidden() {
        XCTAssertFalse(mapView.hamburgerMenuIsVisible)
    }
    
    func testSearchBarText() {
        XCTAssertEqual(mapView.searchBar?.placeholder, "¿Qué estás buscando?")
    }
    
    func testLendButton() {
        XCTAssertFalse(mapView.lendButton.isHidden)
    }

}
