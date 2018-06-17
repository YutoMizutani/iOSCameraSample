//
//  PhotoEditDataStoreTests.swift
//  iOSCameraSampleTests
//
//  Created by YutoMizutani on 2018/06/17.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import XCTest
@testable import iOSCameraSample

class iOSCameraSamplePhotoEditDataStoreTests: XCTestCase {
    var dataStore: PhotoEditDataStore!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.dataStore = PhotoEditDataStoreImpl()
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

    func testPush() {
        let userDefaults = UserDefaults.standard

        self.dataStore.push(true, key: .didEditFlag)
        userDefaults.synchronize()
        XCTAssertTrue(userDefaults.bool(forKey: PhotoEditBoolKeys.didEditFlag.rawValue))

        self.dataStore.push(false, key: .didEditFlag)
        userDefaults.synchronize()
        XCTAssertFalse(userDefaults.bool(forKey: PhotoEditBoolKeys.didEditFlag.rawValue))

        self.dataStore.push(true, key: .didSaveFlag)
        userDefaults.synchronize()
        XCTAssertTrue(userDefaults.bool(forKey: PhotoEditBoolKeys.didSaveFlag.rawValue))

        self.dataStore.push(false, key: .didSaveFlag)
        userDefaults.synchronize()
        XCTAssertFalse(userDefaults.bool(forKey: PhotoEditBoolKeys.didSaveFlag.rawValue))
    }

    func testGet() {
        let userDefaults = UserDefaults.standard

        userDefaults.set(true, forKey: PhotoEditBoolKeys.didEditFlag.rawValue)
        userDefaults.synchronize()
        var result = try? self.dataStore.get(key: .didEditFlag)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, true)

        userDefaults.set(false, forKey: PhotoEditBoolKeys.didEditFlag.rawValue)
        userDefaults.synchronize()
        result = try? self.dataStore.get(key: .didEditFlag)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, false)

        userDefaults.set(true, forKey: PhotoEditBoolKeys.didSaveFlag.rawValue)
        userDefaults.synchronize()
        result = try? self.dataStore.get(key: .didSaveFlag)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, true)

        userDefaults.set(false, forKey: PhotoEditBoolKeys.didSaveFlag.rawValue)
        userDefaults.synchronize()
        result = try? self.dataStore.get(key: .didSaveFlag)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, false)

        userDefaults.reset()
        result = try? self.dataStore.get(key: .didSaveFlag)
        XCTAssertNil(result)

        userDefaults.reset()
        result = try? self.dataStore.get(key: .didEditFlag)
        XCTAssertNil(result)
    }
}

fileprivate extension UserDefaults {
    /// UserDefaultsの初期化
    func reset() {
        let dictionary = self.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            self.removeObject(forKey: key)
        }
        self.synchronize()
    }
}
