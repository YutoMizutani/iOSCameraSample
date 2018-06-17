//
//  MenuUseCaseTests.swift
//  iOSCameraSampleTests
//
//  Created by YutoMizutani on 2018/06/17.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import XCTest
@testable import iOSCameraSample

class iOSCameraSampleMenuUseCaseTests: XCTestCase {
    var useCase: MenuUseCase!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.useCase = self.createMenuUseCase()
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
    
    #if DEBUG
    func testGetStubImage() {
        let image = try? self.useCase.getStubImage()
        XCTAssertNotNil(image)
        XCTAssertEqual(image, UIImage(named: "IMG_1000.JPG"))
    }
    #endif
}
