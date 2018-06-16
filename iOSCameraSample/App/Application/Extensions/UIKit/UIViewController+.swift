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

extension UIViewController {
    func presentAlert(_ title: String, message: String, actionTitle: String="OK") {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .cancel) { _ -> Void in
        })

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

