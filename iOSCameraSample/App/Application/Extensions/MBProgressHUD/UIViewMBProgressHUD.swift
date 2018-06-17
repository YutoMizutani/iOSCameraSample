//
//  UIViewMBProgressHUD.swift
//  iOSCameraSample
//
//  Created by YutoMizutani on 2018/06/16.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation
import MBProgressHUD

extension UIView {
    var hud: (show: (() -> Void), hidden: (() -> Void)) {
        func show() {
            DispatchQueue.main.async {
                let loadingNotification = MBProgressHUD.showAdded(to: self, animated: true)
                loadingNotification.mode = MBProgressHUDMode.indeterminate
            }
        }
        func hidden() {
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self, animated: true)
            }
        }
        return (show, hidden)
    }
}
