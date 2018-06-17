//
//  StampUITests.swift
//  iOSCameraSampleUITests
//
//  Created by YutoMizutani on 2018/06/17.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import XCTest

class iOSCameraSampleEditStampUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        self.app = XCUIApplication()
        self.app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        self.transitionToPhotoEditView(self.app)
        self.transitionToEditStampView(self.app)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK:- NavigationBar

    // NavigationItemの文字を判定する。
    func testEditStampNavigationItem() {
        XCTAssert(self.app.navigationBars["スタンプ"].exists)
    }
}
