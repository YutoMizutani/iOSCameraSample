//
//  PhotoEditWireframe.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

protocol PhotoEditWireframe: class {
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
}
