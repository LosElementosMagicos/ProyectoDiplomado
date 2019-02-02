//
//  Lend_ItUITests.swift
//  Lend ItUITests
//
//  Created by Daniel Esteban Salinas Suárez on 12/24/18.
//  Copyright © 2018 Daniel Esteban Salinas Suárez. All rights reserved.
//

import XCTest

class Lend_ItUITests: XCTestCase {

    static var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        if Lend_ItUITests.app == nil {
            Lend_ItUITests.app = XCUIApplication()
            Lend_ItUITests.app.launch()
            Lend_ItUITests.app.launchArguments.append("--uitesting")
        }
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSignIn() {
        Lend_ItUITests.app.buttons.element.tap()
        //app.swipeLeft()
        //app.buttons["Done"].tap()
        
    }

}
