//
//  MenuUseCase.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/11.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation
#if DEBUG
import UIKit
#endif

protocol MenuUseCase {
    #if DEBUG
    func getStubImage() throws -> UIImage
    #endif
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
    #if DEBUG
    /// 撮影画像のスタブを返す。
    func getStubImage() throws -> UIImage {
        guard let image = AppAssets.stubImage else {
            throw ErrorWhenDebug.pictureNotFound
        }
        return image
    }
    #endif
}
