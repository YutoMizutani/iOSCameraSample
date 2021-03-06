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
    func editContrast(value: Float)
    func addStamp()
}

class PhotoEditPresenterImpl {
    typealias viewInputType = PhotoEditViewInput
    typealias wireframeType = PhotoEditWireframe
    typealias useCaseType = PhotoEditUseCase

    private weak var viewInput: viewInputType?
    private let wireframe: PhotoEditWireframe
    private let useCase: PhotoEditUseCase

    private var imageModel: PhotoEditImageModel?

    private var rawImage: UIImage?

    init(
        viewInput: viewInputType,
        wireframe: wireframeType,
        useCase: useCaseType
        ) {
        self.viewInput = viewInput
        self.useCase = useCase
        self.wireframe = wireframe
        self.configureState()
    }

    private func configureState() {
        self.useCase.changeSaveState(false)
        self.useCase.changeEditState(true)
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

    /// UIImageを表示する。
    func getImageDisposable(_ image: UIImage?) -> BehaviorRelay<UIImage>? {
        guard let image = image else { return nil }
        self.imageModel = self.useCase.getImageModel(image)
        self.rawImage = self.imageModel?.image.value
        return self.imageModel?.image
    }

    /// UIActivityViewControllerを表示する。
    func presentActivity(image: UIImage) {
        self.wireframe.presentActivity(image: image, completionWithItemsHandler: { (activityType, completed, returnedItems, activityError) in
            guard completed else { return }

            // 共有対象の定義
            let targets = [
                UIActivityType.airDrop,
                UIActivityType.mail,
                UIActivityType.markupAsPDF,
                UIActivityType.message,
                UIActivityType.openInIBooks,
                UIActivityType.postToFacebook,
                UIActivityType.postToFlickr,
                UIActivityType.postToTencentWeibo,
                UIActivityType.postToTwitter,
                UIActivityType.postToVimeo,
                UIActivityType.postToWeibo,
                UIActivityType.saveToCameraRoll,
            ]

            // 共有された場合にはSaveされたと判定する。
            if let type = activityType, targets.index(of: type) != nil {
                // 保存フラグを立てる。
                self.useCase.changeSaveState(true)
                self.useCase.changeEditState(false)
            }

            // 保存の定義
            let saveMethods = [
                UIActivityType.saveToCameraRoll,
            ]

            // saveMethodsに一致した場合には画像を保存したと判定する。
            if let type = activityType, saveMethods.index(of: type) != nil {
                // 保存完了のアラートを表示する。
                self.viewInput?.presentAlert(title: "確認", message: "画像の保存が完了しました。")
            }
        })
    }

    /// テキストを追加する。
    func addText() {
        // 編集フラグを立てる。
        self.useCase.changeEditState(true)

        // TextImageViewを追加する。
        let textImageView = TextImageView()
        textImageView.frame = CGRect(x: 0, y: 0, width: 150, height: 100)
        self.viewInput?.addTextImageView(textImageView)
    }

    /// コントラストを編集するViewを呼び出す。
    func editContrast(value: Float) {
        guard let model = self.imageModel else { return }

        if let contrastImage = self.useCase.contrast(self.rawImage!, value: value) {
            model.image.accept(contrastImage)
        }
    }

    /// スタンプを表示するViewを呼び出す。
    func addStamp() {
        let collections: [UIImage] = (1...9).map{ PhotoEditCollectionItems.stamp(index: $0) }.filter{ $0 != nil }.map{ $0! }
        self.wireframe.presentStampCollection(images: collections, onSelect: { [weak self] image in
            // 編集フラグを立てる。
            self?.useCase.changeEditState(true)

            let stampImageView = StampImageView()
            stampImageView.inject(image)
            stampImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            self?.viewInput?.addStampImageView(stampImageView)
        })
    }
}
