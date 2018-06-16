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
    func presentActivity(image: UIImage, completionWithItemsHandler: ((_ activityType: UIActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ activityError: Error?) -> Void)?)
    func presentStampCollection(images: [UIImage], onSelect: @escaping ((UIImage?) -> Void))
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
        self.viewController?.dismiss(animated: true, completion: nil)
    }

    func presentActivity(image: UIImage, completionWithItemsHandler: ((_ activityType: UIActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ activityError: Error?) -> Void)?) {
        let activityItems = [image]
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = completionWithItemsHandler

        // iPad使用時にクラッシュしないようにする表示起点の設定。
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

    func presentStampCollection(images: [UIImage], onSelect: @escaping ((UIImage?) -> Void)) {
        let collectionViewController = EditStampViewController(onSelect: onSelect)
        let navigationViewController = UINavigationController(rootViewController: collectionViewController)
        navigationViewController.title = "スタンプ"
        self.viewController?.present(navigationViewController, animated: true, completion: nil)
    }
}
