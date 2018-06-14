//
//  PhotoEditUseCase.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

protocol PhotoEditUseCase {
    func getStatus() -> PhotoEditModel
    func changeSaveState(_ state: Bool)
    func changeEditState(_ state: Bool)
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
    func getStatus() -> PhotoEditModel {
        let entity = self.repository.getState()
        return self.translator.translate(from: entity)
    }
    func changeSaveState(_ state: Bool) {
        self.repository.setDidSaveState(state)
    }
    func changeEditState(_ state: Bool) {
        self.repository.setDidEditState(state)
    }
}
