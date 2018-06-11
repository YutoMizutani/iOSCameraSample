//
//  MenuRepository.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/11.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

protocol MenuRepository {
}


struct MenuRepositoryImpl {
    typealias dataStoreType = MenuDataStore

    private let dataStore: dataStoreType

    init(
        dataStore: dataStoreType
        ) {
        self.dataStore = dataStore
    }
}

extension MenuRepositoryImpl: MenuRepository {
}
