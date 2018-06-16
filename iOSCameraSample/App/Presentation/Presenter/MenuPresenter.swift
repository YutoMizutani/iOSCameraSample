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
    func launchCamera(_ delegate: UIViewController?)
    func transitionEdit(with image: UIImage)
    #if DEBUG
    func stubCamera()
    #endif
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
    /// カメラを起動する。
    func launchCamera(_ delegate: UIViewController?) {
        let mediaType: AVMediaType = .video
        let status = AVCaptureDevice.authorizationStatus(for: mediaType)
        switch status {
        // 選択していない場合，または許可されている場合
        case .notDetermined, .authorized:
            // カメラを表示する。
            self.launch(delegate)
        // アクセスがユーザーにより拒否されている場合
        case .denied:
            DispatchQueue.main.async {
                // 許可リクエストを行う。
                AVCaptureDevice.requestAccess(for: mediaType, completionHandler: { bool in
                    if bool {
                        // カメラを表示する。
                        self.launch(delegate)
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

    func transitionEdit(with image: UIImage) {
        self.wireframe.transitionPhotoEdit(image: image)
    }

    #if DEBUG
    /// カメラの起動時間やシャッター音防止のためのスタブ画像経由で遷移する。
    func stubCamera() {
        do {
            let stubImage = try self.useCase.getStubImage()
            self.wireframe.transitionPhotoEdit(image: stubImage)
        }catch let e {
            self.viewInput?.throwError(e)
        }
    }
    #endif
}

extension MenuPresenterImpl {
    func launch(_ delegate: UIViewController?) {
        var resultImage: UIImage? = nil
        let completion: (() -> Void) = {
            if let image = resultImage {
                self.wireframe.transitionPhotoEdit(image: image)
            }
        }

        UIImagePickerController.rx.createWithParent(delegate, completion: completion) { picker in
            picker.sourceType = .camera
            picker.allowsEditing = false
            }
            .flatMap { $0.rx.didFinishPickingMediaWithInfo }
            .take(1)
            .map{ $0[UIImagePickerControllerOriginalImage] }.filter{ $0 != nil }.map{ $0! }
            .map { info in
                return info as? UIImage
            }
            .subscribe(onNext: { image in
                resultImage = image
            })
            .disposed(by: disposeBag)
    }
}
