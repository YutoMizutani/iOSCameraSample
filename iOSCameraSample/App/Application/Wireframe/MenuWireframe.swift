//
//  MenuWireframe.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/11.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

protocol MenuWireframe: class {
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
}
