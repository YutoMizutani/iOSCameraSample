//
//  PhotoEditUITests.swift
//  iOSCameraSampleUITests
//
//  Created by YutoMizutani on 2018/06/17.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import XCTest

class iOSCameraSamplePhotoEditUITests: XCTestCase {
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
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK:- NavigationBar

    // NavigationItemの文字を判定する。
    func testPhotoEditNavigationItem() {
        let navigationBar = self.app.navigationBars["画像の編集"]
        XCTAssert(navigationBar.exists)
        XCTAssertTrue(navigationBar.isEnabled)
    }

    // MARK:- UIToolbar

    // コントラストボタンを判定する。
    func testPhotoEditButton() {
        let button = self.app.buttons["contrastButton"]
        XCTAssert(button.exists)
        XCTAssertTrue(button.isEnabled)
    }

    // アクティビティボタンを判定する。
    func testPhotoEditActivityButton() {
        let button = self.app.buttons["activityButton"]
        XCTAssert(button.exists)
        XCTAssertTrue(button.isEnabled)
    }

    // テキストボタンを判定する。
    func testPhotoEditTextButton() {
        let button = self.app.buttons["textButton"]
        XCTAssert(button.exists)
        XCTAssertTrue(button.isEnabled)
    }

    // スタンプボタンを判定する。
    func testPhotoEditStampButton() {
        let button = self.app.buttons["stampButton"]
        XCTAssert(button.exists)
        XCTAssertTrue(button.isEnabled)
    }
}
