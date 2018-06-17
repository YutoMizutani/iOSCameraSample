//
//  PhotoEditSaveStateModel.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol PhotoEditSaveStateModel {
    var didSaveFlag: Bool { get }
    var didEditFlag: Bool { get }
}

/// 画像の編集状態を管理するstruct。
struct PhotoEditSaveStateModelImpl: PhotoEditSaveStateModel {
    /// 保存フラグ。これまで保存されたかの状態を保持する。
    let didSaveFlag: Bool
    /// 編集フラグ。前回保存した状態からの変化を保持する。
    let didEditFlag: Bool
}

protocol PhotoEditAlertModel {
    var title: String { get }
    var message: String { get }
    var done: (String, (()->Void)) { get }
    var cancel: (String, (()->Void)?) { get }
}

/// 編集状態を通知するUIAlertControllerのViewModel。
struct PhotoEditAlertModelImpl: PhotoEditAlertModel {
    let title: String
    let message: String
    let done: (String, (()->Void))
    let cancel: (String, (()->Void)?)
}

protocol PhotoEditImageModel {
    var image: BehaviorRelay<UIImage> { get }
}

/// UIImageViewのViewModel。
struct PhotoEditImageModelImpl: PhotoEditImageModel {
    var image: BehaviorRelay<UIImage>

    init(image: UIImage) {
        self.image = BehaviorRelay(value: image)
    }
}
