//
//  MenuTranslatorTests.swift
//  iOSCameraSampleTests
//
//  Created by YutoMizutani on 2018/06/17.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import XCTest
@testable import iOSCameraSample

class iOSCameraSampleMenuTranslatorTests: XCTestCase {
    var translator: MenuTranslator!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.translator = MenuTranslatorImpl()
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
        let model = MenuModelImpl()
        let entity = self.translator.translate(from: model) as? MenuEntityImpl
        XCTAssertNotNil(entity)
        XCTAssertEqual(entity!, MenuEntityImpl())
    }

    func testTranslateFromEntityToModel() {
        let entity = MenuEntityImpl()
        let model = self.translator.translate(from: entity) as? MenuModelImpl
        XCTAssertNotNil(model)
        XCTAssertEqual(model!, MenuModelImpl())
    }
}
