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
import AVFoundation

protocol MenuPresenter: class {
    func launchCamera()
}

class MenuPresenterImpl {
    typealias viewInputType = MenuViewInput
    typealias wireframeType = MenuWireframe
    typealias useCaseType = MenuUseCase

    private weak var viewInput: viewInputType?
    private let wireframe: MenuWireframe
    private let useCase: MenuUseCase

    private let disposeBag = DisposeBag()

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
    func launchCamera() {
        let mediaType: AVMediaType = .video
        let status = AVCaptureDevice.authorizationStatus(for: mediaType)
        switch status {
        // 選択していない場合，または許可されている場合
        case .notDetermined, .authorized:
            // カメラを表示する。
            self.launch()
        // アクセスがユーザーにより拒否されている場合
        case .denied:
            DispatchQueue.main.async {
                // 許可リクエストを行う。
                AVCaptureDevice.requestAccess(for: mediaType, completionHandler: { bool in
                    if bool {
                        // カメラを表示する。
                        self.launch()
                    }else{
                        // アラートを表示する。
                        let error = ErrorCameraUsage.permissionDenied
                        self.viewInput?.throwError(error)
                    }
                })
            }
        // カメラの使用が制限されている場合
        case .restricted:
            // アラートを表示する。
            let error = ErrorCameraUsage.permissionRestricted
            self.viewInput?.throwError(error)
        }
    }
}

extension MenuPresenterImpl {
    func launch() {
        // 即発火するObservableを作成する。
        let observable = Observable<Void>.create { observer in
            observer.onNext()
            observer.onCompleted()
            return Disposables.create()
        }
        
        observable
            .observeOn(MainScheduler.instance)
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self?.viewInput?.delegate) { picker in
                    picker.sourceType = .camera
                    picker.allowsEditing = false
                }
            }
            .flatMap { $0.rx.didFinishPickingMediaWithInfo }
            .map { info in
                return info[UIImagePickerControllerOriginalImage] as? UIImage
            }
            .catchError({ [weak self] error -> Observable<UIImage?> in
                self?.viewInput?.throwError(error)
                return Observable.empty()
            })
            .asObservable()
            .subscribe(onNext: { [weak self] image in
                guard let image = image else {
                    let error = ErrorCameraUsage.failedCreateImage
                    self?.viewInput?.throwError(error)
                    return
                }
                // TODO: 将来的に破棄される。
                /// 一時的に確認するfunction
                self?.viewInput?.previewImage(image)
            })
            .disposed(by: disposeBag)
    }
}
