//
//  UnitTest+.swift
//  iOSCameraSampleTests
//
//  Created by YutoMizutani on 2018/06/17.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import XCTest
@testable import iOSCameraSample

extension XCTestCase {
    func createMenuUseCase() -> MenuUseCase {
        return MenuUseCaseImpl(
            repository: MenuRepositoryImpl (
                dataStore: MenuDataStoreImpl()
            ),
            translator: MenuTranslatorImpl()
        )
    }

    func createPhotoEditUseCase() -> PhotoEditUseCase {
        return PhotoEditUseCaseImpl(
            repository: PhotoEditRepositoryImpl (
                dataStore: PhotoEditDataStoreImpl()
            ),
            translator: PhotoEditTranslatorImpl()
        )
    }
}
