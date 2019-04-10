//
//  StudorUITests.swift
//  StudorUITests
//
//  Created by Sean Bamford on 3/17/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import XCTest

class StudorUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        XCUIApplication().terminate()
    }
    
    func testExplore() {
        
        let app = XCUIApplication()
        app.textFields["email"].tap()
        app.typeText("james@gcc.edu")
        app.secureTextFields["password"].tap()
        app.typeText("1234567")
        app.buttons["Log In"].tap()
        
        /*app.tables/*@START_MENU_TOKEN@*/.staticTexts["billy"]/*[[".cells.staticTexts[\"billy\"]",".staticTexts[\"billy\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Profile"].buttons["Messages"].tap()
        app.textViews.staticTexts["New Message"].tap()
        app.typeText("Hello there")
        app.buttons["Send"].tap()
        app.navigationBars["james billy"].children(matching: .button).element(boundBy: 1).tap()*/
        
        
        _ = XCUIApplication()
        let tablesQuery = app.tables
        let billyStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["billy"]/*[[".cells.staticTexts[\"billy\"]",".staticTexts[\"billy\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        billyStaticText.tap()
        
        let profileNavigationBar = app.navigationBars["Profile"]
        profileNavigationBar.buttons["Messages"].tap()
        app.textViews.staticTexts["New Message"].tap()
        app.typeText("Hello There")
        app.buttons["Send"].tap()
        app.navigationBars["james billy"].children(matching: .button).element(boundBy: 1).tap()
        app.textFields["Event Title"].tap()
        app.typeText("New Event")
        
        let participantsTextField = app.textFields["Participants"]
        participantsTextField.tap()
        billyStaticText.tap()
        
        let button = app.buttons["+"]
        button.tap()
        
        //let okButton = app.alerts["ERR"].buttons["OK"]
        //okButton.tap()
        participantsTextField.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["ayyyy"]/*[[".cells.staticTexts[\"ayyyy\"]",".staticTexts[\"ayyyy\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        button.tap()
        //okButton.tap()
        app.textFields["Location"].tap()
        app.typeText("There")
        
        app.textFields["Location"].tap()
        app.textFields["Location"].tap()
        app.textFields["Location"].tap()
        app.textFields["Location"].tap()
        app.textFields["Location"].tap()
        app.textFields["Location"].tap()
        app.textFields["Location"].tap()
        app.textFields["Location"].tap()
        app.textFields["Location"].tap()
        app.textFields["Location"].tap()
        app.textFields["Location"].tap()
        app.textFields["Location"].tap()
        app.textFields["Location"].tap()
        app.textFields["Location"].tap()
        app.textFields["Location"].tap()
        app.textFields["Location"].tap()
        app.textFields["Location"].tap()
        app.textFields["Location"].tap()
        
        let createEventNavigationBar = app.navigationBars["Create Event"]
        createEventNavigationBar.buttons["Create"].tap()
        
        let emptyListTable = app.tables["Empty list"]
        emptyListTable.swipeDown()
        emptyListTable.swipeDown()
        app.navigationBars["Schedule"].buttons["Add"].tap()
        createEventNavigationBar.buttons["Cancel"].tap()
        app.tabBars.buttons["Profile"].tap()
        profileNavigationBar.buttons["Sign Out"].tap()
        
        
    }

    func testProfile() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        app.textFields["email"].tap()
        app.typeText("james@gcc.edu")
        app.secureTextFields["password"].tap()
        app.typeText("1234567")
        app.buttons["Log In"].tap()
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Messages"].tap()
        tabBarsQuery.buttons["Events"].tap()
        tabBarsQuery.buttons["Profile"].tap()
        
        
        
        _ = XCUIApplication()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button).matching(identifier: "Edit").element(boundBy: 0).tap()
        app.alerts["Edit Nickname"].buttons["Save"].tap()
        //element.children(matching: .button).matching(identifier: "Edit").element(boundBy: 1).tap()
        //app.alerts["Edit Bio"].buttons["Save"].tap()
        app.buttons["+"].tap()
        app.textFields["Search Courses..."].tap()
        
        let comp314StaticText = app.tables/*@START_MENU_TOKEN@*/.staticTexts["COMP 314"]/*[[".cells.staticTexts[\"COMP 314\"]",".staticTexts[\"COMP 314\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        comp314StaticText.tap()
        app.buttons["Add Course"].tap()
        app.navigationBars["Studor.TagSearchView"].buttons["Profile"].tap()
        app.buttons["Trash"].tap()
        comp314StaticText.swipeLeft()
        app.buttons["Delete"].tap()
        app.navigationBars["Studor.DeleteTagsView"].buttons["Profile"].tap()
        app.navigationBars["Profile"].buttons["Sign Out"].tap()
        
        
    }
    
    func testSignUp() {
        
        let app = XCUIApplication()
        app.buttons["Sign Up"].tap()
        app.textFields["Email"].tap()
        app.typeText("yaaay@gcc.edu")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()
        app.typeText("1234567")
        app.secureTextFields["Confirm Password"].tap()
        app.typeText("1234567")
        app/*@START_MENU_TOKEN@*/.buttons["Tutor"]/*[[".segmentedControls.buttons[\"Tutor\"]",".buttons[\"Tutor\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Create Account"].tap()
        app.tabBars.buttons["Profile"].tap()
        app.navigationBars["Profile"].buttons["Sign Out"].tap()
        
        
    }
    
    func testExplorePage() {
        
        let app = XCUIApplication()
        app.textFields["email"].tap()
        app.typeText("james@gcc.edu")
        app.secureTextFields["password"].tap()
        app.typeText("1234567")
        app.buttons["Log In"].tap()
        
        let searchSearchField = app/*@START_MENU_TOKEN@*/.searchFields["Search"]/*[[".otherElements[\"Search Bar\"].searchFields[\"Search\"]",".searchFields[\"Search\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        searchSearchField.tap()
        searchSearchField.tap()
        searchSearchField.tap()
        searchSearchField.tap()
        
        let studentsButton = app/*@START_MENU_TOKEN@*/.buttons["Students"]/*[[".otherElements[\"Search Bar\"]",".segmentedControls[\"scopeBar\"].buttons[\"Students\"]",".buttons[\"Students\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        studentsButton.tap()
        
        let tutorsButton = app/*@START_MENU_TOKEN@*/.buttons["Tutors"]/*[[".otherElements[\"Search Bar\"]",".segmentedControls[\"scopeBar\"].buttons[\"Tutors\"]",".buttons[\"Tutors\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        tutorsButton.tap()
        
        let app2 = app
        app2/*@START_MENU_TOKEN@*/.buttons["Groups"]/*[[".otherElements[\"Search Bar\"]",".segmentedControls[\"scopeBar\"].buttons[\"Groups\"]",".buttons[\"Groups\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app2/*@START_MENU_TOKEN@*/.buttons["All"]/*[[".otherElements[\"Search Bar\"]",".segmentedControls[\"scopeBar\"].buttons[\"All\"]",".buttons[\"All\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        searchSearchField.typeText("tyler")
        studentsButton.tap()
        tutorsButton.tap()
        app2.tables/*@START_MENU_TOKEN@*/.staticTexts["tyler"]/*[[".cells.staticTexts[\"tyler\"]",".staticTexts[\"tyler\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let profileNavigationBar = app.navigationBars["Profile"]
        profileNavigationBar.buttons["Explore"].tap()
        app.tabBars.buttons["Profile"].tap()
        profileNavigationBar.buttons["Sign Out"].tap()
        
    }
    
    func testMessage() {
        
        let app = XCUIApplication()
        app.textFields["email"].tap()
        app.typeText("james@gcc.edu")
        app.secureTextFields["password"].tap()
        app.typeText("1234567")
        app.buttons["Log In"].tap()
        
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["ayyyy"]/*[[".cells.staticTexts[\"ayyyy\"]",".staticTexts[\"ayyyy\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Profile"].buttons["Messages"].tap()
        app.textViews.containing(.staticText, identifier:"New Message").element.tap()
        app.typeText("Message")
        app.buttons["Send"].tap()
        app.navigationBars["james ayyyy"].buttons["Profile"].tap()
        app.tabBars.buttons["Profile"].tap()
        app.navigationBars["Profile"].buttons["Sign Out"].tap()
        
        
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
    
    //func testEvents() {
    
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
    //}
    
    func testGroups() {
        
        let app = XCUIApplication()
        app.textFields["email"].tap()
        app.typeText("james@gcc.edu")
        app.secureTextFields["password"].tap()
        app.typeText("1234567")
        app.buttons["Log In"].tap()
        app.tabBars.buttons["Messages"].tap()
        app.tabBars.buttons["Messages"].tap()
        app.tabBars.buttons["Messages"].tap()
        app.tabBars.buttons["Messages"].tap()
        app.tabBars.buttons["Messages"].tap()
        app.tabBars.buttons["Messages"].tap()
        app.tabBars.buttons["Messages"].tap()
        app.tabBars.buttons["Messages"].tap()
        app.tabBars.buttons["Messages"].tap()
        app.tabBars.buttons["Messages"].tap()
        app.tabBars.buttons["Messages"].tap()
        app.tabBars.buttons["Messages"].tap()
        app.tabBars.buttons["Messages"].tap()
        app.tabBars.buttons["Messages"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.cells.containing(.staticText, identifier:"newgroup6").staticTexts["Group Channel"].tap()
        app.textViews.staticTexts["New Message"].tap()
        app.typeText("Hello There")
        app.buttons["Send"].tap()
        app.navigationBars["newgroup6"].buttons["My Channels"].tap()
        app.navigationBars["My Channels"].buttons["Create Group"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .textField).element(boundBy: 0).tap()
        element.children(matching: .textField).element(boundBy: 0).typeText("Test Group 3")
        element.children(matching: .textField).element(boundBy: 1).tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["yaay"]/*[[".cells.staticTexts[\"yaay\"]",".staticTexts[\"yaay\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Add"].tap()
        app.buttons["Confirm"].tap()
        
        app.tabBars.buttons["Profile"].tap()
        app.navigationBars["Profile"].buttons["Sign Out"].tap()
        
        
    }


}
