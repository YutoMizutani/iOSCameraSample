//
//  PhotoEditTranslatorTests.swift
//  iOSCameraSampleTests
//
//  Created by YutoMizutani on 2018/06/17.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import XCTest
@testable import iOSCameraSample

class iOSCameraSamplePhotoEditTranslatorTests: XCTestCase {
    var translator: PhotoEditTranslator!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.translator = PhotoEditTranslatorImpl()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    // MARK:- functions

    func testTranslateFromModelToEntity() {
        var model = PhotoEditSaveStateModelImpl(didSaveFlag: true, didEditFlag: false)
        var entity = self.translator.translate(from: model) as? PhotoEditSaveStateEntityImpl
        XCTAssertNotNil(entity)
        XCTAssertEqual(entity!, PhotoEditSaveStateEntityImpl(didSaveFlag: true, didEditFlag: false))

        model = PhotoEditSaveStateModelImpl(didSaveFlag: false, didEditFlag: true)
        entity = self.translator.translate(from: model) as? PhotoEditSaveStateEntityImpl
        XCTAssertNotNil(entity)
        XCTAssertEqual(entity!, PhotoEditSaveStateEntityImpl(didSaveFlag: false, didEditFlag: true))
    }

    func testTranslateFromEntityToModel() {
        var entity = PhotoEditSaveStateEntityImpl(didSaveFlag: true, didEditFlag: nil)
        var model = self.translator.translate(from: entity) as? PhotoEditSaveStateModelImpl
        XCTAssertNotNil(model)
        XCTAssertEqual(model!, PhotoEditSaveStateModelImpl(didSaveFlag: true, didEditFlag: false))

        entity = PhotoEditSaveStateEntityImpl(didSaveFlag: false, didEditFlag: true)
        model = self.translator.translate(from: entity) as? PhotoEditSaveStateModelImpl
        XCTAssertNotNil(model)
        XCTAssertEqual(model!, PhotoEditSaveStateModelImpl(didSaveFlag: false, didEditFlag: true))

        entity = PhotoEditSaveStateEntityImpl(didSaveFlag: nil, didEditFlag: false)
        model = self.translator.translate(from: entity) as? PhotoEditSaveStateModelImpl
        XCTAssertNotNil(model)
        XCTAssertEqual(model!, PhotoEditSaveStateModelImpl(didSaveFlag: false, didEditFlag: false))
    }
}
