//
//  PhotoEditUseCase.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

protocol PhotoEditUseCase {
}

struct PhotoEditUseCaseImpl {
    typealias repositoryType = PhotoEditRepository
    typealias translatorType = PhotoEditTranslator

    private let repository: repositoryType
    private let translator: translatorType

    init(
        repository: repositoryType,
        translator: translatorType
        ) {
        self.repository = repository
        self.translator = translator
    }
}

extension PhotoEditUseCaseImpl: PhotoEditUseCase {
}
