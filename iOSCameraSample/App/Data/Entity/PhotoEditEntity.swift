//
//  PhotoEditSaveStateEntity.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

protocol PhotoEditSaveStateEntity {
    var didSaveFlag: Bool { get }
    var didEditFlag: Bool { get }

    init(didSaveFlag: Bool?, didEditFlag: Bool?)
}

struct PhotoEditSaveStateEntityImpl: PhotoEditSaveStateEntity {
    /// 保存フラグ。これまで保存されたかの状態を保持する。
    let didSaveFlag: Bool
    /// 編集フラグ。前回保存した状態からの変化を保持する。
    let didEditFlag: Bool

    init(didSaveFlag: Bool? = nil, didEditFlag: Bool? = nil) {
        self.didSaveFlag = didSaveFlag ?? false
        self.didEditFlag = didEditFlag ?? false
    }
}

extension PhotoEditSaveStateEntityImpl: Equatable {
    static func == (lhs: PhotoEditSaveStateEntityImpl, rhs: PhotoEditSaveStateEntityImpl) -> Bool {
        return lhs.didSaveFlag == rhs.didSaveFlag && lhs.didEditFlag == rhs.didEditFlag
    }
}
