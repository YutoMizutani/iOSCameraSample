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

    /// イメージが生成できなかった場合
    case failedCreateImage
}
