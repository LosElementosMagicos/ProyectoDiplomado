//
//  Lend_ItUITests.swift
//  Lend ItUITests
//
//  Created by Daniel Esteban Salinas Suárez on 12/24/18.
//  Copyright © 2018 Daniel Esteban Salinas Suárez. All rights reserved.
//

import XCTest

class Lend_ItUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        // Log into the app if nedded before every test
        if !app.buttons["button lend it"].exists {
            let facebookSignInButton = app.buttons["facebook"]
            facebookSignInButton.tap()
            app.tap()
            
            let webView = app.descendants(matching: .webView)
            webView.buttons["Continuar"].tap()
        }
        wait(for: app.buttons["button lend it"], timeout: 3.0)
    }

    override func tearDown() {
        // This method is called after the invocation of each test method in the class.
        // Log out of app
        app.buttons["Configuración"].tap()
        app.tables.staticTexts["Cerrar sesión"].tap()
    }
    
    func testNewItem() {
        
        app.buttons["button lend it"].tap()
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.otherElements.textFields["Ej. Martillo Cat"].tap()
        app.keys["T"].tap()
        app.keys["e"].tap()
        app.keys["s"].tap()
        app.keys["t"].tap()
        
        let element = scrollViewsQuery.children(matching: .other).element
        element.children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .button).matching(identifier: "Button").element(boundBy: 0).tap()
        app.buttons["Cancel"].tap()
        element.children(matching: .other).element(boundBy: 2).children(matching: .textField).element.tap()
        app.keys["1"].tap()
        app.keys["0"].tap()
        app.keys["0"].tap()
        element.tap()
        app.navigationBars["Lend_It.AddItemView"].buttons["Cancel"].tap()
        app.navigationBars["Lend_It.MapView"].buttons["Item"].tap()
    }
    
    func testHamburguerMenu() {
        // Profile
        app.navigationBars["Lend_It.MapView"].buttons["Item"].tap()
        app.buttons["editar"].tap()
        app.buttons["verificado"].tap()
        app.keys["1"].tap()
        app.keys["2"].tap()
        app.navigationBars["Lend It"].buttons["Back"].tap()
        app.navigationBars["Mi Perfil"].buttons["Back"].tap()
        // My items
        app.buttons["Mis objetos"].tap()
        app.navigationBars["Mis Objetos"].buttons["Back"].tap()
        // Rented items
        app.buttons["Objetos rentados"].tap()
        app.navigationBars["Mis Rentados"].buttons["Back"].tap()
        // Help
        app.buttons["Ayuda"].tap()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["¿Cómo puedo rentar?"].tap()
        let helpButton = app.navigationBars["Lend_It.HelpView"].buttons["Ayuda"]
        helpButton.tap()
        tablesQuery.staticTexts["No aparece el objeto que estoy buscando."].tap()
        helpButton.tap()
        app.navigationBars["Ayuda"].buttons["Done"].tap()
        // Configuration
        app.buttons["Configuración"].tap()
        app.navigationBars["Configuración"].buttons["Done"].tap()
    }

}


extension XCTestCase {
/// Wait for element to appear
    func wait(for element: XCUIElement, timeout duration: TimeInterval) {
        let predicate = NSPredicate(format: "exists == true")
        let _ = expectation(for: predicate, evaluatedWith: element, handler: nil)
        // We use a buffer here to avoid flakiness with Timer on CI
        waitForExpectations(timeout: duration + 0.5)
    }
}
