//
//  PhotoEditModel.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol PhotoEditModel {
    var didSaveFlag: BehaviorRelay<Bool> { get }
    var didEditFlag: BehaviorRelay<Bool> { get }
}

struct PhotoEditModelImpl: PhotoEditModel {
    /// 保存フラグ。これまで保存されたかの状態を保持する。
    private(set) var didSaveFlag: BehaviorRelay<Bool>
    /// 編集フラグ。前回保存した状態からの変化を保持する。
    private(set) var didEditFlag: BehaviorRelay<Bool>

    init(didSaveFlag: Bool, didEditFlag: Bool) {
        self.didSaveFlag = BehaviorRelay(value: didSaveFlag)
        self.didEditFlag = BehaviorRelay(value: didEditFlag)
    }
}
