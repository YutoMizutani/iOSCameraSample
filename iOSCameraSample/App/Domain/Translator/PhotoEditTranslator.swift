//
//  PhotoEditTranslator.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

protocol PhotoEditTranslator {
    func translate(from model: PhotoEditSaveStateModel) -> PhotoEditSaveStateEntity
    func translate(from entity: PhotoEditSaveStateEntity) -> PhotoEditSaveStateModel
}

struct PhotoEditTranslatorImpl: PhotoEditTranslator {
    func translate(from model: PhotoEditSaveStateModel) -> PhotoEditSaveStateEntity {
        return PhotoEditSaveStateEntityImpl(didSaveFlag: model.didSaveFlag, didEditFlag: model.didEditFlag)
    }
    func translate(from entity: PhotoEditSaveStateEntity) -> PhotoEditSaveStateModel {
        return PhotoEditSaveStateModelImpl(didSaveFlag: entity.didSaveFlag, didEditFlag: entity.didEditFlag)
    }
}
