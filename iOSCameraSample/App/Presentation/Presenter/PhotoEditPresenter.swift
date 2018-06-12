//
//  PhotoEditPresenter.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

protocol PhotoEditPresenter: class {
}

class PhotoEditPresenterImpl {
    typealias viewInputType = PhotoEditViewInput
    typealias wireframeType = PhotoEditWireframe
    typealias useCaseType = PhotoEditUseCase

    private weak var viewInput: viewInputType?
    private let wireframe: PhotoEditWireframe
    private let useCase: PhotoEditUseCase

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

extension PhotoEditPresenterImpl: PhotoEditPresenter {
}
