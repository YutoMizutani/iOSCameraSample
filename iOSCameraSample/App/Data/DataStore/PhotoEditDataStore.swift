//
//  PhotoEditDataStore.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

protocol PhotoEditDataStore {
    func push(_ state: Bool, key: PhotoEditBoolKeys)
    func get(key: PhotoEditBoolKeys) throws -> Bool
}

struct PhotoEditDataStoreImpl: PhotoEditDataStore {
    /// UserDefaultsにstateを保存する。
    func push(_ state: Bool, key: PhotoEditBoolKeys) {
        let userDefaults = UserDefaults.standard
        let key = key.rawValue
        userDefaults.set(state, forKey: key)
    }

    /// UserDefaultsに保存されている値を取り出す。
    func get(key: PhotoEditBoolKeys) throws -> Bool {
        let userDefaults = UserDefaults.standard
        let key = key.rawValue
        // 存在しない場合はエラーを返す。
        if userDefaults.object(forKey: key) == nil {
            throw ErrorUserDefaults.notFound
        }

        return userDefaults.bool(forKey: key)
    }
}
