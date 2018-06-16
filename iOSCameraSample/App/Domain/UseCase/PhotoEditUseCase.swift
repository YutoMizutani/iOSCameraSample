//
//  PhotoEditUseCase.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoEditUseCase {
    func getSaveStateModel() -> PhotoEditSaveStateModel
    func getImageModel(_ image: UIImage) -> PhotoEditImageModel
    func changeSaveState(_ state: Bool)
    func changeEditState(_ state: Bool)
    func contrast(_ image: UIImage, value: Float) -> UIImage?
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
    func getSaveStateModel() -> PhotoEditSaveStateModel {
        let entity = self.repository.getState()
        return self.translator.translate(from: entity)
    }
    func getImageModel(_ image: UIImage) -> PhotoEditImageModel {
        return PhotoEditImageModelImpl(image: image)
    }
    func changeSaveState(_ state: Bool) {
        self.repository.setDidSaveState(state)
    }
    func changeEditState(_ state: Bool) {
        self.repository.setDidEditState(state)
    }

    func contrast(_ image: UIImage, value: Float) -> UIImage? {
        let ciImage = CIImage(cgImage: image.cgImage!)
        let contrastCIImage = ciImage.applyColorControls([(CIColorControlsType.contrast, value)])
        let uiImage = CIContextInstance.shared.generate(from: contrastCIImage, orientation: image.imageOrientation)
        return uiImage
    }
}
