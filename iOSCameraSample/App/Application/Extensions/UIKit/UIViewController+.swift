//
//  UIViewController+.swift
//  iOSCameraSample
//
//  Created by YutoMizutani on 2018/06/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

extension UIViewController {
    /// 最も手前にあるUIViewControllerを取得する。
    var front: UIViewController? {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            var frontViewControlelr: UIViewController = rootViewController

            while let presentedViewController = frontViewControlelr.presentedViewController {
                frontViewControlelr = presentedViewController
            }

            return frontViewControlelr
        } else {
            return nil
        }
    }
}
