//
//  MenuEntity.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/11.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

protocol MenuEntity {
}

struct MenuEntityImpl: MenuEntity {
}

extension MenuEntityImpl: Equatable {
    static func == (lhs: MenuEntityImpl, rhs: MenuEntityImpl) -> Bool {
        // valueがないのでtrue。
        return true
    }
}
