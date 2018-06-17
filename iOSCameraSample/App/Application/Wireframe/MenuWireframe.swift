//
//  MenuWireframe.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/11.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

protocol MenuWireframe: class {
    func transitionPhotoEdit(image: UIImage)
}

class MenuWireframeImpl {
    private weak var viewController: UIViewController?

    init(
        viewController: UIViewController
        ) {
        self.viewController = viewController
    }
}

extension MenuWireframeImpl: MenuWireframe {
    func transitionPhotoEdit(image: UIImage) {
        let modalController = PhotoEditBuilder().buildWithNavigationController(image: image)
        modalController.modalPresentationStyle = .overCurrentContext
        self.viewController?.present(modalController, animated: true, completion: nil)
    }
}
