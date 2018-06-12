//
//  PhotoEditEntity.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

protocol PhotoEditEntity {
    var didSaveFlag: Bool { get }
    var didEditFlag: Bool { get }
}

struct PhotoEditEntityImpl: PhotoEditEntity {
    /// 保存フラグ。これまで保存されたかの状態を保持する。
    let didSaveFlag: Bool
    /// 編集フラグ。前回保存した状態からの変化を保持する。
    let didEditFlag: Bool
}
