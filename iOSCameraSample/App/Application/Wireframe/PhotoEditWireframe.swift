//
//  PhotoEditWireframe.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

protocol PhotoEditWireframe: class {
    func dismiss()
    func presentActivity(image: UIImage)
}

class PhotoEditWireframeImpl {
    private weak var viewController: UIViewController?

    init(
        viewController: UIViewController
        ) {
        self.viewController = viewController
    }
}

extension PhotoEditWireframeImpl: PhotoEditWireframe {
    func dismiss() {
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }

    func presentActivity(image: UIImage) {
        let activityItems = [image]
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

        // iPad時にクラッシュしないようにする表示起点の設定。
        activityViewController.popoverPresentationController?.sourceView = self.viewController?.view

        // 使用しないUIActivityType
        let excludedActivityTypes: [UIActivityType] = [
            // 画像が利用されないUIActivityTypeを除外する。
            UIActivityType.postToTwitter,
            UIActivityType.addToReadingList,
            UIActivityType.assignToContact,
            UIActivityType.print
        ]

        activityViewController.excludedActivityTypes = excludedActivityTypes
        self.viewController?.present(activityViewController, animated: true, completion: nil)
    }
}
