//
//  UITest+.swift
//  iOSCameraSampleUITests
//
//  Created by YutoMizutani on 2018/06/17.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import XCTest

extension XCTestCase {
    /// PhotoEditViewに遷移する。
    func transitionToPhotoEditView(_ app: XCUIApplication) {
        let button = app.buttons["stubCameraButton"]
        XCTAssert(button.exists)
        XCTAssertTrue(button.isEnabled)
        button.tap()
    }

    /// EditTextViewに遷移する。
    func transitionToEditTextView(_ app: XCUIApplication) {
        let button = app.toolbars.buttons["textButton"]
        XCTAssertTrue(false)

        
        XCTAssert(button.exists)
        XCTAssertTrue(button.isEnabled)
        button.tap()
    }

    /// PhotoEditViewに遷移する。
    func transitionToEditStampView(_ app: XCUIApplication) {
        let button = app.toolbars.buttons["stampButton"]
        XCTAssert(button.exists)
        XCTAssertTrue(button.isEnabled)
        button.tap()
    }
}
