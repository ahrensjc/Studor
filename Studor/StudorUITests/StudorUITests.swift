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
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["billy"]/*[[".cells.staticTexts[\"billy\"]",".staticTexts[\"billy\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Profile"].buttons["Messages"].tap()
        app.textViews.staticTexts["New Message"].tap()
        app.buttons["Send"].tap()
        app.navigationBars["ahrensjc1 billy"].children(matching: .button).element(boundBy: 1).tap()
        
    }

    func testProfile() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Messages"].tap()
        tabBarsQuery.buttons["Events"].tap()
        tabBarsQuery.buttons["Profile"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        let editButton = element.children(matching: .button).matching(identifier: "Edit").element(boundBy: 0)
        editButton.tap()
        
        let editNicknameAlert = app.alerts["Edit Nickname"]
        editNicknameAlert.buttons["Cancel"].tap()
        editButton.tap()
        editNicknameAlert.buttons["Save"].tap()
        
        let editButton2 = element.children(matching: .button).matching(identifier: "Edit").element(boundBy: 1)
        editButton2.tap()
        
        let editBioAlert = app.alerts["Edit Bio"]
        editBioAlert.buttons["Cancel"].tap()
        editButton2.tap()
        editBioAlert.buttons["Save"].tap()
        app.buttons["+"].tap()
        app.textFields["Search Courses..."].tap()
        app.typeText("COMP 314")
        app.buttons["Add Course"].tap()
        app.navigationBars["Studor.TagSearchView"].buttons["Profile"].tap()
        app.buttons["Trash"].tap()
        
        let tablesQuery = app.tables
    
        let comp314StaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["COMP 314"]/*[[".cells.staticTexts[\"COMP 314\"]",".staticTexts[\"COMP 314\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        comp314StaticText.swipeLeft()
        tablesQuery.buttons["Delete"].tap()

        
        
        app.navigationBars["Studor.DeleteTagsView"].buttons["Profile"].tap()
        tabBarsQuery.buttons["Explore"].tap()
        
    }

}
