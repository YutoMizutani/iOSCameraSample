//
//  PhotoEditBuilder.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

struct PhotoEditBuilder {
    func build(with image: UIImage) -> UIViewController {
        let viewController = PhotoEditViewController()
        viewController.inject(
            presenter: PhotoEditPresenterImpl(
                viewInput: viewController,
                wireframe: PhotoEditWireframeImpl(
                    viewController: viewController
                ),
                useCase: PhotoEditUseCaseImpl(
                    repository: PhotoEditRepositoryImpl (
                        dataStore: PhotoEditDataStoreImpl()
                    ),
                    translator: PhotoEditTranslatorImpl()
                )
            ),
            image: image
        )
        return viewController
    }
    func buildWithNavigationController(title: String, image: UIImage) -> UINavigationController {
        let viewController = self.build(with: image)
        viewController.navigationItem.title = title
        let navigationController = UINavigationController.init(rootViewController: viewController)
        return navigationController
    }
}
