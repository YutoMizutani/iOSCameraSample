//
//  PhotoEditTranslator.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

protocol PhotoEditTranslator {
    func translate(from model: PhotoEditModel) -> PhotoEditEntity
    func translate(from entity: PhotoEditEntity) -> PhotoEditModel
}

struct PhotoEditTranslatorImpl: PhotoEditTranslator {
    func translate(from model: PhotoEditModel) -> PhotoEditEntity {
        return PhotoEditEntityImpl(didSaveFlag: model.didSaveFlag.value, didEditFlag: model.didEditFlag.value)
    }
    func translate(from entity: PhotoEditEntity) -> PhotoEditModel {
        return PhotoEditModelImpl(didSaveFlag: entity.didSaveFlag, didEditFlag: entity.didEditFlag)
    }
}
