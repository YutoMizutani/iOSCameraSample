//
//  MenuUITests.swift
//  iOSCameraSampleUITests
//
//  Created by YutoMizutani on 2018/06/17.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import XCTest

class iOSCameraSampleMenuUITests: XCTestCase {
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
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK:- NavigationBar

    // NavigationItemの文字を判定する。
    func testMenuNavigationItem() {
        XCTAssert(self.app.navigationBars["iOSCameraSample"].exists)
    }

    // カメラ起動ボタンを判定する。
    func testMenuLaunchCameraButton() {
        let button = self.app.buttons["launchCameraButton"]
        XCTAssert(button.exists)
        XCTAssertTrue(button.isEnabled)
        XCTAssertEqual(button.label, "Launch camera")
    }

    // スタブボタンを判定する。
    func testMenuStubCameraButton() {
        let button = self.app.buttons["stubCameraButton"]
        XCTAssert(button.exists)
        XCTAssertTrue(button.isEnabled)
        XCTAssertEqual(button.label, "Stub camera")
    }
}
