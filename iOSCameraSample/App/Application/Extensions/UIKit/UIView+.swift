//
//  UIView+.swift
//  iOSCameraSample
//
//  Created by YutoMizutani on 2018/06/14.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

extension UIView {
    /// addSubViewした先のViewControllerを取得する。
    public var parent: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

extension UIView {
    /// UIViewを複製する。
    public var duplicated: UIView? {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as? UIView
    }
}
