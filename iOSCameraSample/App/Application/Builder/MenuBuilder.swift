//
//  MenuBuilder.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/11.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

struct MenuBuilder {
    func build() -> UIViewController {
        let viewController = MenuViewController()
        viewController.inject(
            presenter: MenuPresenterImpl(
                viewInput: viewController,
                wireframe: MenuWireframeImpl(
                    viewController: viewController
                ),
                useCase: MenuUseCaseImpl(
                    repository: MenuRepositoryImpl (
                        dataStore: MenuDataStoreImpl()
                    ),
                    translator: MenuTranslatorImpl()
                )
            )
        )
        return viewController
    }
    func buildWithNavigationController() -> UINavigationController {
        let viewController = self.build()
        let navigationController = UINavigationController.init(rootViewController: viewController)
        return navigationController
    }
}
