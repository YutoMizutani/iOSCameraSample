//
//  PhotoEditPresenter.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol PhotoEditPresenter: class {
    func dismiss()
    func getImageDisposable(_ image: UIImage?) -> BehaviorRelay<UIImage>?
    func presentActivity(image: UIImage)
    func addText()
    func compose(image: UIImage)
}

class PhotoEditPresenterImpl {
    typealias viewInputType = PhotoEditViewInput
    typealias wireframeType = PhotoEditWireframe
    typealias useCaseType = PhotoEditUseCase

    private weak var viewInput: viewInputType?
    private let wireframe: PhotoEditWireframe
    private let useCase: PhotoEditUseCase

    private var imageModel: PhotoEditImageModel?

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
        let editStatus = self.useCase.getSaveStateModel()

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

    func getImageDisposable(_ image: UIImage?) -> BehaviorRelay<UIImage>? {
        guard let image = image else { return nil }
        self.imageModel = self.useCase.getImageModel(image)
        return self.imageModel?.image
    }

    /// UIActivityViewControllerを表示する。
    func presentActivity(image: UIImage) {
        self.wireframe.presentActivity(image: image)
    }

    /// Textを追加する。
    func addText() {
        let textImageView = TextImageView()
        textImageView.frame = CGRect(x: 0, y: 0, width: 150, height: 100)
        self.viewInput?.addTextImageView(textImageView)
    }

    /// 画像を合成する。
    func compose(image: UIImage) {
//        if let composed = model.image.value.composed(with: images) {
//            model.image.accept(image)
//            textImageViews.accept([])
//        }
    }
}
