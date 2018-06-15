//
//  UIImageView+.swift
//  iOSCameraSample
//
//  Created by YutoMizutani on 2018/06/15.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

extension UIImageView {
    /// imageViewのlayerを元にUIImageを作成する。
    var layerImage: UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
