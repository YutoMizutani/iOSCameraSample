//
//  PhotoEditRepository.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

protocol PhotoEditRepository {
    func getState() -> PhotoEditSaveStateEntity
    func setDidSaveState(_ state: Bool)
    func setDidEditState(_ state: Bool)
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
    /// 編集状態を取得する。
    func getState() -> PhotoEditSaveStateEntity {
        // ここで生じるエラーは保存されていない場合のみ。Entityでnilを補完するため，try?でnilを許容する。
        let didSaveFlag = try? self.dataStore.get(key: .didSaveFlag)
        let didEditFlag = try? self.dataStore.get(key: .didEditFlag)

        // Entityを生成して返す。
        return PhotoEditSaveStateEntityImpl(didSaveFlag: didSaveFlag, didEditFlag: didEditFlag)
    }

    /// 保存状態を更新する。
    func setDidSaveState(_ state: Bool) {
        self.dataStore.push(state, key: .didSaveFlag)
    }
    
    /// 編集状態を更新する。
    func setDidEditState(_ state: Bool) {
        self.dataStore.push(state, key: .didEditFlag)
    }
}
