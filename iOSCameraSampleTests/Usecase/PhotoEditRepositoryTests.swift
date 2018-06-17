//
//  PhotoEditRepositoryTests.swift
//  iOSCameraSampleTests
//
//  Created by YutoMizutani on 2018/06/17.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import XCTest
@testable import iOSCameraSample

fileprivate struct PhotoEditDataStoreMockSuccess: PhotoEditDataStore {
    func push(_ state: Bool, key: PhotoEditBoolKeys) {
    }
    func get(key: PhotoEditBoolKeys) throws -> Bool {
        return true
    }
}
fileprivate struct PhotoEditDataStoreMockFailed: PhotoEditDataStore {
    func push(_ state: Bool, key: PhotoEditBoolKeys) {
    }
    func get(key: PhotoEditBoolKeys) throws -> Bool {
        throw ErrorUserDefaults.notFound
    }
}

class iOSCameraSamplePhotoEditRepositoryTests: XCTestCase {
    var repository: (success: PhotoEditRepository, failed: PhotoEditRepository)!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.repository = (
            success: PhotoEditRepositoryImpl(dataStore: PhotoEditDataStoreMockSuccess()),
            failed: PhotoEditRepositoryImpl(dataStore: PhotoEditDataStoreMockFailed())
        )
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

    func testGetState() {
        success: do {
            let repository = self.repository.success
            let entity = repository.getState() as? PhotoEditSaveStateEntityImpl
            XCTAssertNotNil(entity)
            XCTAssertEqual(entity!, PhotoEditSaveStateEntityImpl(didSaveFlag: true, didEditFlag: true))
        }
        failed: do {
            let repository = self.repository.failed
            let entity = repository.getState() as? PhotoEditSaveStateEntityImpl
            XCTAssertNotNil(entity)
            XCTAssertEqual(entity!, PhotoEditSaveStateEntityImpl(didSaveFlag: false, didEditFlag: false))
        }
    }

    func testSetDidSaveState() {
        success: do {
            let repository = self.repository.success
            repository.setDidEditState(true)
            repository.setDidEditState(false)
        }
        failed: do {
            let repository = self.repository.failed
            repository.setDidEditState(true)
            repository.setDidEditState(false)
        }
    }

    func testSetDidEditState() {
        success: do {
            let repository = self.repository.success
            repository.setDidSaveState(true)
            repository.setDidSaveState(false)
        }
        failed: do {
            let repository = self.repository.failed
            repository.setDidSaveState(true)
            repository.setDidSaveState(false)
        }
    }
}
