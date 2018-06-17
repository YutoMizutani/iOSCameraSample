//
//  Assets.swift
//  iOSCameraSample
//
//  Created by YutoMizutani on 2018/06/13.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

struct AppAssets {
    static var name: String {
        return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "iOSCameraSample"
    }
}

enum PhotoEditBoolKeys: String {
    case didSaveFlag = "didSaveFlag"
    case didEditFlag = "didEditFlag"
}
