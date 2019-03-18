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
    
    func testTags() {
        
        let app = XCUIApplication()
        app.textFields["email"].tap()
        app.typeText("james@gcc.edu")
        app.textFields["password"].tap()
        app.typeText("1234567")
        app.buttons["Log In"].tap()
        app.tabBars.children(matching: .button).element(boundBy: 3).tap()
        app.buttons["TAGS"].tap()
        app.textFields["Search Tags..."].tap()
        app.typeText("Bio")
        app.buttons["Add tag"].tap()
        app.navigationBars["Studor.TagSearchView"].buttons["Profile"].tap()
        app.buttons["Delete Tags"].tap()
        app.tables.staticTexts["Bio"].tap()
        app.navigationBars["Studor.DeleteTagsView"].buttons["Profile"].tap()
        app.navigationBars["Profile"].buttons["Sign Out"].tap()
        
    }
    
    func testMessages() {
        
        let app = XCUIApplication()
        app.textFields["email"].tap()
        app.typeText("james@gcc.edu")
        app.textFields["password"].tap()
        app.typeText("1234567")
        app.buttons["Log In"].tap()
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.children(matching: .button).element(boundBy: 1).tap()
        
        
        let label = app.tables/*@START_MENU_TOKEN@*/.staticTexts["new group 5"]/*[[".cells.staticTexts[\"new group 5\"]",".staticTexts[\"new group 5\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let exists = NSPredicate(format: "exists == 1")
        
        expectation(for: exists, evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["new group 5"]/*[[".cells.staticTexts[\"new group 5\"]",".staticTexts[\"new group 5\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.textViews.staticTexts["New Message"].tap()
        app.typeText("test message")
        app.buttons["Send"].tap()
        app.navigationBars["Title"].buttons["Messages"].tap()
        tabBarsQuery.children(matching: .button).element(boundBy: 3).tap()
        app.navigationBars["Profile"].buttons["Sign Out"].tap()
        
        
    }
    
    func testMakeGroup() {
        let app = XCUIApplication()
        app.textFields["email"].tap()
        app.typeText("james@gcc.edu")
        app.textFields["password"].tap()
        app.typeText("1234567")
        app.buttons["Log In"].tap()
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.children(matching: .button).element(boundBy: 1).tap()
        
        let createGroupButton = app.navigationBars["Messages"].buttons["Create Group"]
        createGroupButton.tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .textField).element(boundBy: 0).tap()
        app.typeText("deleteMe")
        
        let textField = element.children(matching: .textField).element(boundBy: 1)
        textField.tap()
        app.typeText("user1")
        
        let addButton = app.buttons["Add"]
        addButton.tap()
        textField.tap()
        app.typeText("user2")
        addButton.tap()
        app.buttons["Confirm"].tap()
        createGroupButton.tap()
        app.buttons["Cancel"].tap()
        tabBarsQuery.children(matching: .button).element(boundBy: 3).tap()
        app.navigationBars["Profile"].buttons["Sign Out"].tap()
        
        
        
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
    
    func testEvents() {
        
        let app = XCUIApplication()
        app.textFields["email"].tap()
        app.typeText("james@gcc.edu")
        app.textFields["password"].tap()
        app.typeText("1234567")
        app.buttons["Log In"].tap()
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.children(matching: .button).element(boundBy: 2).tap()
        
        let addEventButton = app.navigationBars["Schedule"].buttons["Add Event"]
        addEventButton.tap()
        
        let eventTitleTextField = app.textFields["Event Title"]
        eventTitleTextField.tap()
        app.typeText("deleteMe")
        app.textFields["Participants"].tap()
        app.typeText("user1")
        app.buttons["Add"].tap()
        app.datePickers.pickerWheels["Today"].swipeUp()
        app.textFields["Location"].tap()
        app.typeText("nowhere")
        
        let window = app.children(matching: .window).element(boundBy: 0)
        let textView = window.children(matching: .other).element(boundBy: 2).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element
        textView.tap()
        textView.tap()
        
        let createEventNavigationBar = app.navigationBars["Create Event"]
        createEventNavigationBar.buttons["Create"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Add Event"]/*[[".cells.staticTexts[\"Add Event\"]",".staticTexts[\"Add Event\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Edit Event"].tap()
        window.children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element(boundBy: 1).tap()
        app.typeText("a")
        app.buttons["Confirm"].tap()
        app.navigationBars["Studor.EditEventView"].buttons["Back"].tap()
        app.navigationBars["Studor.EventView"].buttons["Schedule"].tap()
        addEventButton.tap()
        createEventNavigationBar.buttons["Cancel"].tap()
        tabBarsQuery.children(matching: .button).element(boundBy: 3).tap()
        app.navigationBars["Profile"].buttons["Sign Out"].tap()
        
    }

}
