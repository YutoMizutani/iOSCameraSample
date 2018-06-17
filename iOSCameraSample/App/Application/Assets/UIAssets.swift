//
//  UIAssets.swift
//  iOSCameraSample
//
//  Created by YutoMizutani on 2018/06/14.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

#if DEBUG
extension AppAssets {
    /// 撮影画像のスタブ
    static var stubImage: UIImage? {
        return UIImage(named: "IMG_1000.JPG")
    }
}
#endif

struct PhotoEditToolIcons {
    static var text: UIImage? {
        return UIImage(named: "text.png")?.resize(for: CGSize(width: 32, height: 44))
    }
    static var contrast: UIImage? {
        return UIImage(named: "contrast.png")?.resize(for: CGSize(width: 32, height: 44))
    }
    static var stamp: UIImage? {
        return UIImage(named: "stamp.png")?.resize(for: CGSize(width: 32, height: 44))
    }
}

struct PhotoEditCollectionItems {
    static func stamp(index: Int) -> UIImage? {
        return UIImage(named: "stamp\(index).png")
    }
}
