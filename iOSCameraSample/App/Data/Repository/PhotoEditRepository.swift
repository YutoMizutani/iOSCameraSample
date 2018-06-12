//
//  PhotoEditRepository.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

protocol PhotoEditRepository {
}

struct PhotoEditRepositoryImpl {
    typealias dataStoreType = PhotoEditDataStore

    private let dataStore: dataStoreType

    init(
        dataStore: dataStoreType
        ) {
        self.dataStore = dataStore
    }
}

extension PhotoEditRepositoryImpl: PhotoEditRepository {
}
