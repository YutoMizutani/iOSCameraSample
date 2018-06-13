//
//  UIBarButtonItem+.swift
//  iOSCameraSample
//
//  Created by YutoMizutani on 2018/06/14.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    enum HiddenItem: Int {
        case arrow = 100
        case back = 101
        case forward = 102
        case up = 103
        case down = 104
    }

    convenience init(barButtonHiddenItem: HiddenItem, target: Any?, action: Selector?) {
        let systemItem = UIBarButtonSystemItem(rawValue: barButtonHiddenItem.rawValue)
        self.init(barButtonSystemItem: systemItem!, target: target, action: action)
    }
}
