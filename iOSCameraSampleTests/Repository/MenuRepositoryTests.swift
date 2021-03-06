//
//  MenuRepositoryTests.swift
//  iOSCameraSampleTests
//
//  Created by YutoMizutani on 2018/06/17.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import XCTest
@testable import iOSCameraSample

fileprivate struct MenuDataStoreMock: MenuDataStore {
}

class iOSCameraSampleMenuRepositoryTests: XCTestCase {
    var repository: MenuRepository!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.repository = MenuRepositoryImpl(dataStore: MenuDataStoreMock())
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
}
