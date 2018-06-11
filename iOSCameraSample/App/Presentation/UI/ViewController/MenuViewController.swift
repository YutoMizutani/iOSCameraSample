//
//  MenuViewController.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/11.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol MenuViewInput: class {
    func showAlert(error: Error)
    // TODO: 将来的に破棄される。
    func previewImage(_ image: UIImage)
}


class MenuViewController: UIViewController {
    typealias presenterType = MenuPresenter

    private var presenter: presenterType?
    private var subview: MenuView?

    private let disposeBag = DisposeBag()

    internal func inject(
        presenter: presenterType
        ) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        layoutView()
        binding()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        layoutView()

        self.view.layoutIfNeeded()
    }
}

extension MenuViewController {
    private func configureView() {
        selfView: do {
            self.view.backgroundColor = UIColor.white
        }
        subview: do {
            self.subview = MenuView(frame: self.view.bounds)
            if self.subview != nil {
                self.view.addSubview(self.subview!)
            }
        }
    }
    private func layoutView() {
        subview: do {
            self.subview?.frame = self.view.bounds
        }
    }
}

extension MenuViewController {
    private func binding() {
        if let subview = self.subview {
            self.presenter?.launch(subview.launchCameraButton.rx.tap, delegate: self)
                .disposed(by: disposeBag)
        }
    }
}

// MARK:- Public methods accessed from other classes
extension MenuViewController: MenuViewInput, ErrorShowable {
    /// アラートを表示する。
    public func showAlert(error: Error) {
        self.showAlert(error: error)
    }

    // TODO: 将来的に破棄される。
    /// 画像をモーダル表示する一時的なfunction。
    public func previewImage(_ image: UIImage) {
        let modalController = PresentationController()
        modalController.inject(image)
        modalController.modalPresentationStyle = .overCurrentContext
        DispatchQueue.main.async {
            self.present(modalController, animated: true, completion: nil)
        }
    }
}

// TODO: 将来的に破棄される。
/// 撮影を確認する一時的なViewController。
fileprivate class PresentationController: UIViewController {
    var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.imageView)
        layoutView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        layoutView()

        self.view.layoutIfNeeded()
    }

    func inject(_ image: UIImage) {
        self.imageView = UIImageView(image: image)
    }

    func layoutView() {
        self.imageView.frame = self.view.frame
    }
}
