//
//  Error.swift
//  iOSCameraSample
//
//  Created by YutoMizutani on 2018/06/11.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

enum ErrorCameraUsage: Error {
    /// カメラが使用不可能な場合
    case unavailable

    /// アクセス拒否をした場合
    case permissionDenied

    /// アクセス制限がされている場合
    case permissionRestricted

    /// イメージが生成できなかった場合
    case failedCreateImage
}

#if DEBUG
enum ErrorWhenDebug: Error {
    /// 画像を生成できなかった場合
    case pictureNotFound
}
#endif

enum ErrorUserDefaults: Error {
    /// 値が存在しない場合
    case notFound
}

/// 画像の編集状態を把握する。アラートの文言に使用し，挙動には影響しない。
enum ErrorSaveEditingPicture: Error {
    /// 一度も保存されていない場合
    case neverSaved

    /// 前回の保存からの変更が保存されていない場合
    case notSavedWhenPreviousChanges
}
