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
    /// 保存状態のModelを取得する。
    func getSaveStateModel() -> PhotoEditSaveStateModel {
        let entity = self.repository.getState()
        return self.translator.translate(from: entity)
    }

    /// UIImageView用のViewModelを取得する。
    func getImageModel(_ image: UIImage) -> PhotoEditImageModel {
        return PhotoEditImageModelImpl(image: image)
    }

    /// 保存状態の変更を適用する。
    func changeSaveState(_ state: Bool) {
        self.repository.setDidSaveState(state)
    }

    /// 編集状態の変更を適用する。
    func changeEditState(_ state: Bool) {
        self.repository.setDidEditState(state)
    }

    /// コントラストを適用する。
    func contrast(_ image: UIImage, value: Float) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        let contrastCIImage = ciImage.applyColorControls([(CIColorControlsType.contrast, value)])
        let uiImage = CIContextInstance.shared.generate(from: contrastCIImage, orientation: image.imageOrientation)
        return uiImage
    }
}
