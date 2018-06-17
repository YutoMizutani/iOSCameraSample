//
//  PhotoEditUseCaseTests.swift
//  iOSCameraSampleTests
//
//  Created by YutoMizutani on 2018/06/17.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import XCTest
@testable import iOSCameraSample

class iOSCameraSamplePhotoEditUseCaseTests: XCTestCase {
    var useCase: PhotoEditUseCase!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.useCase = self.createPhotoEditUseCase()
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

    /// 保存状態のModelの取得を判定する。
    func testGetSaveStateModel() {
        /// ABA design
        // A
        let model = self.useCase.getSaveStateModel()
        self.useCase.changeEditState(!model.didEditFlag)
        self.useCase.changeSaveState(!model.didSaveFlag)
        // B (!A)
        var changed = self.useCase.getSaveStateModel()
        // A != B
        XCTAssertNotEqual(model.didEditFlag, changed.didEditFlag)
        XCTAssertNotEqual(model.didSaveFlag, changed.didSaveFlag)
        self.useCase.changeEditState(!changed.didEditFlag)
        self.useCase.changeSaveState(!changed.didSaveFlag)
        // A
        changed = self.useCase.getSaveStateModel()
        // A == A
        XCTAssertEqual(model.didEditFlag, changed.didEditFlag)
        XCTAssertEqual(model.didSaveFlag, changed.didSaveFlag)
    }

    /// UIImageView用のViewModel生成を判定する。
    func testGetImageModel() {
        let image = UIImage()
        let model = self.useCase.getImageModel(image)
        XCTAssertEqual(model.image.value, image)
        XCTAssertEqual(model.image.value, PhotoEditImageModelImpl(image: image).image.value)
    }

    /// 保存状態の変更を判定する。
    func testChangeSaveState() {
        var state = true
        self.useCase.changeSaveState(state)
        XCTAssertEqual(self.useCase.getSaveStateModel().didSaveFlag, state)
        state = false
        self.useCase.changeSaveState(state)
        XCTAssertEqual(self.useCase.getSaveStateModel().didSaveFlag, state)
    }

    /// 編集状態の変更を判定する。
    func testChangeEditState() {
        var state = true
        self.useCase.changeEditState(state)
        XCTAssertEqual(self.useCase.getSaveStateModel().didEditFlag, state)
        state = false
        self.useCase.changeEditState(state)
        XCTAssertEqual(self.useCase.getSaveStateModel().didEditFlag, state)
    }

    /// コントラストを判定する。
    func testContrast() {
        let image = UIImage(named: "IMG_1000.JPG")
        XCTAssertNotNil(image)
        let applied = self.useCase.contrast(image!, value: 1.5)
        XCTAssertNotNil(applied)
    }
}
