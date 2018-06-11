//
//  MenuUseCase.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/11.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

protocol MenuUseCase {
}


struct MenuUseCaseImpl {
    typealias repositoryType = MenuRepository
    typealias translatorType = MenuTranslator

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

extension MenuUseCaseImpl: MenuUseCase {
}
