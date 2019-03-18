//
//  LogInUITest.swift
//  Studor
//
//  Created by Sean Bamford on 3/17/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import XCTest

class LogInUITest: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
    }
    
    func testSignUp() {
        
        let app = XCUIApplication()
        app.buttons["Sign Up"].tap()
        app.textFields["Email"].tap()
        app.typeText("emailaddress4@gcc.edu")
        let passwordTextField = app.textFields["Password"]
        passwordTextField.tap()
        passwordTextField.tap()
        app.typeText("password")
        let confirmPasswordTextField = app.textFields["Confirm Password"]
        confirmPasswordTextField.tap()
        confirmPasswordTextField.tap()
        app.typeText("password")
        app.buttons["Create Account"].tap()
        app.tabBars.children(matching: .button).element(boundBy: 3).tap()
        app.navigationBars["Profile"].buttons["Sign Out"].tap()
        
    }
    
    func testGeneral() {
        let app = XCUIApplication()
        app.textFields["email"].tap()
        app.typeText("james@gcc.edu")
        app.textFields["password"].tap()
        app.typeText("1234567")
        app.buttons["Log In"].tap()
        app.tables.children(matching: .cell).element(boundBy: 0).staticTexts["tylerfehr4"].tap()
        app.buttons["like"].tap()
        
        let profileNavigationBar = app.navigationBars["Profile"]
        profileNavigationBar.buttons["Explore"].tap()
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.children(matching: .button).element(boundBy: 1).tap()
        tabBarsQuery.children(matching: .button).element(boundBy: 2).tap()
        app.navigationBars["Schedule"].buttons["Add Event"].tap()
        app.navigationBars["Create Event"].buttons["Cancel"].tap()
        tabBarsQuery.children(matching: .button).element(boundBy: 3).tap()
        profileNavigationBar.buttons["Sign Out"].tap()
    }
    
    func testLoginAndSignout() {
        let app = XCUIApplication()
        app.textFields["email"].tap()
        app.typeText("james@gcc.edu")
        app.textFields["password"].tap()
        app.typeText("1234567")
        app.buttons["Log In"].tap()
        app.tabBars.children(matching: .button).element(boundBy: 3).tap()
        app.navigationBars["Profile"].buttons["Sign Out"].tap()
    }
    
    func testProfileEdit() {
        
        let app = XCUIApplication()
        app.textFields["email"].tap()
        app.typeText("james@gcc.edu")
        app.textFields["password"].tap()
        app.typeText("1234567")
        app.buttons["Log In"].tap()
        app.tabBars.children(matching: .button).element(boundBy: 3).tap()
        
        let element2 = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        let editButton = element2.children(matching: .button).matching(identifier: "Edit").element(boundBy: 0)
        editButton.tap()
        
        let cancelButton = app.buttons["Cancel"]
        cancelButton.tap()
        editButton.tap()
        
        let element = element2.children(matching: .other).element(boundBy: 2)
        element.children(matching: .textField).element.tap()
        app.buttons["Done"].tap()
        element2.children(matching: .button).matching(identifier: "Edit").element(boundBy: 1).tap()
        
        let textView = element.children(matching: .textView).element
        textView.tap()
        textView.tap()
        cancelButton.tap()
        app.navigationBars["Profile"].buttons["Sign Out"].tap()
        
    }

}
