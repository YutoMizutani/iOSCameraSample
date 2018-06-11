//
//  MenuPresenter.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/11.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

protocol MenuPresenter: class {
}

class MenuPresenterImpl {
    typealias viewInputType = MenuViewInput
    typealias wireframeType = MenuWireframe
    typealias useCaseType = MenuUseCase

    private weak var viewInput: viewInputType?
    private let wireframe: MenuWireframe
    private let useCase: MenuUseCase

    init(
        viewInput: viewInputType,
        wireframe: wireframeType,
        useCase: useCaseType
        ) {
        self.viewInput = viewInput
        self.useCase = useCase
        self.wireframe = wireframe
    }
}

extension MenuPresenterImpl: MenuPresenter {
}
