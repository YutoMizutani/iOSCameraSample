//
//  PhotoEditPresenter.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

protocol PhotoEditPresenter: class {
    func dismiss()
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
    /// 画像を破棄して終了する。
    func dismiss() {
        let editStatus = self.useCase.getStatus()

        // 編集状態によってアラートを表示する。
        if !editStatus.didSaveFlag || editStatus.didEditFlag {
            let title = "確認"
            let message: String = (!editStatus.didSaveFlag) ? "写真が保存されていません。\n本当に編集を終了しますか?" : "編集した写真が保存されていません。\n本当に編集を終了しますか?"
            let done: (String, (()->Void)) = ("終了", self.wireframe.dismiss)
            let cancel: (String, (()->Void)?) = ("キャンセル", nil)

            let model = PhotoEditAlertModelImpl(title: title, message: message, done: done, cancel: cancel)

            self.viewInput?.presentSelect(model)
            return
        }

        self.wireframe.dismiss()
    }
}
