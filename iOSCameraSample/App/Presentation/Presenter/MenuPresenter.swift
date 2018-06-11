//
//  MenuPresenter.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/11.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MenuPresenter: class {
    func launch(_ action: ControlEvent<Void>, delegate: UIViewController?) -> Disposable
}

class MenuPresenterImpl {
    typealias viewInputType = MenuViewInput
    typealias wireframeType = MenuWireframe
    typealias useCaseType = MenuUseCase

    private weak var viewInput: viewInputType?
    private let wireframe: MenuWireframe
    private let useCase: MenuUseCase

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

extension MenuPresenterImpl: MenuPresenter {
    func launch(_ action: ControlEvent<Void>, delegate: UIViewController?) -> Disposable {
        return action
            .flatMapLatest { _ in
                return UIImagePickerController.rx.createWithParent(delegate) { picker in
                    picker.sourceType = .camera
                    picker.allowsEditing = false
                }
                .flatMap { $0.rx.didFinishPickingMediaWithInfo }
                .take(1)
            }
            .map { info in
                return info[UIImagePickerControllerOriginalImage] as? UIImage
            }
            .catchError({ [weak self] error -> Observable<UIImage?> in
                self?.viewInput?.showAlert(error: error)
                return Observable.empty()
            })
            .asObservable()
            .subscribe(onNext: { [weak self] image in
                guard let image = image else {
                    let error = ErrorCameraUsage.failedCreateImage
                    self?.viewInput?.showAlert(error: error)
                    return
                }
                // TODO: 将来的に破棄される。
                /// 一時的に確認するfunction
                self?.viewInput?.previewImage(image)
            })
    }
}
