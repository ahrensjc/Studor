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
        app.typeText("woooooow@gcc.edu")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()
        app.typeText("1234567")
        app.secureTextFields["Confirm Password"].tap()
        app.typeText("1234567")
        app/*@START_MENU_TOKEN@*/.buttons["Tutor"]/*[[".segmentedControls.buttons[\"Tutor\"]",".buttons[\"Tutor\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Create Account"].tap()
        app.tabBars.children(matching: .button).element(boundBy: 3).tap()
        app.navigationBars["Profile"].buttons["Sign Out"].tap()
        
        
    }
    
    func testTags() {
        let app = XCUIApplication()
        app.textFields["email"].tap()
        app.typeText("james@gcc.edu")
        app.secureTextFields["password"].tap()
        app.typeText("1234567")
        app.buttons["Log In"].tap()
        
        _ = XCUIApplication()
        app.tabBars.buttons["Profile"].tap()
        app.buttons["+"].tap()
        app.textFields["Search Courses..."].tap()
        
        let tablesQuery = app.tables
        let comp314StaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["COMP 314"]/*[[".cells.staticTexts[\"COMP 314\"]",".staticTexts[\"COMP 314\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        comp314StaticText.tap()
        app.buttons["Add Course"].tap()
        app.navigationBars["Studor.TagSearchView"].buttons["Profile"].tap()
        app.buttons["Trash"].tap()
        comp314StaticText.swipeLeft()
        tablesQuery.buttons["Delete"].tap()
        app.navigationBars["Studor.DeleteTagsView"].buttons["Profile"].tap()
        app.navigationBars["Profile"].buttons["Sign Out"].tap()
        
    }
    
    func testMessages() {
        
    }
    
    func testMakeGroup() {
        
        /*let app = XCUIApplication()
        app.textFields["email"].tap()
        app.typeText("james@gcc.edu")
        app.secureTextFields["password"].tap()
        app.typeText("1234567")
        app.buttons["Log In"].tap()
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Messages"].tap()
        app.navigationBars["My Channels"].buttons["Create Group"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        let textField = element.children(matching: .textField).element(boundBy: 1)
        app.textFields["groupName"].tap()
        app.typeText("newgroup5")
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["test5"]/*[[".cells.staticTexts[\"test5\"]",".staticTexts[\"test5\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let addButton = app.buttons["Add"]
        addButton.tap()
        textField.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["test4"]/*[[".cells.staticTexts[\"test4\"]",".staticTexts[\"test4\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        addButton.tap()
        element.children(matching: .textField).element(boundBy: 0).tap()
        app.buttons["Confirm"].tap()
        tabBarsQuery.buttons["Profile"].tap()
        app.navigationBars["Profile"].buttons["Sign Out"].tap()*/
        
        
        
    }
    
    func testLoginAndSignout() {
        let app = XCUIApplication()
        app.textFields["email"].tap()
        app.typeText("james@gcc.edu")
        app.secureTextFields["password"].tap()
        app.typeText("1234567")
        app.buttons["Log In"].tap()
        app.tabBars.children(matching: .button).element(boundBy: 3).tap()
        app.navigationBars["Profile"].buttons["Sign Out"].tap()
    }
    
    func testProfileEdit() {
        
        /*let app = XCUIApplication()
        app.textFields["email"].tap()
        app.typeText("james@gcc.edu")
        app.secureTextFields["password"].tap()
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
        app.navigationBars["Profile"].buttons["Sign Out"].tap()*/
        
    }
    
    func testLikeDislike() {
        
        let app = XCUIApplication()
        app.textFields["email"].tap()
        app.typeText("james@gcc.edu")
        app.secureTextFields["password"].tap()
        app.typeText("1234567")
        app.buttons["Log In"].tap()
        app.tables.cells.containing(.staticText, identifier:"ayyyy").staticTexts["Tutor"].tap()
        
        
        _ = XCUIApplication()
        //app.tables/*@START_MENU_TOKEN@*/.staticTexts["ayyyy"]/*[[".cells.staticTexts[\"ayyyy\"]",".staticTexts[\"ayyyy\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let likeButton = app.buttons["like"]
        likeButton.tap()
        
        let likecolorButton = app.buttons["likeColor"]
        likecolorButton.tap()
        
        let dislikeButton = app.buttons["dislike"]
        dislikeButton.tap()
        app.buttons["dislikeColor"].tap()
        likeButton.tap()
        dislikeButton.tap()
        likeButton.tap()
        likecolorButton.tap()
        app.tabBars.buttons["Profile"].tap()
        app.navigationBars["Profile"].buttons["Sign Out"].tap()
        
        
        
    }
    
    func testEvents() {
        
        /*let app = XCUIApplication()
        app.textFields["email"].tap()
        app.typeText("james@gcc.edu")
        app.secureTextFields["password"].tap()
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
        */
    }

}
