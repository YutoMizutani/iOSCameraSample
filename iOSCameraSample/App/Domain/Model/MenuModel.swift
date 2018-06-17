//
//  MenuModel.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/11.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

protocol MenuModel {
}

struct MenuModelImpl: MenuModel {
}

extension MenuModelImpl: Equatable {
    static func == (lhs: MenuModelImpl, rhs: MenuModelImpl) -> Bool {
        // valueがないのでtrue。
        return true
    }
}
