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
    var delegate: UIViewController { get }
    func throwError(_ error: Error)
}


class MenuViewController: UIViewController {
    typealias presenterType = MenuPresenter

    private var presenter: presenterType?
    private var subview: MenuView?

    private var image = BehaviorRelay<UIImage?>(value: nil)

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
        view: do {
            self.navigationItem.title = AppAssets.name
            self.view.backgroundColor = UIColor.white
        }
        subview: do {
            self.subview = MenuView()
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
        self.subview?.launchCameraButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.presenter?.launchCamera(self)
            })
            .disposed(by: disposeBag)

        #if DEBUG
        self.subview?.stubCameraButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.presenter?.stubCamera()
            })
            .disposed(by: disposeBag)
        #endif
    }
}

// MARK:- Public methods accessed from other classes
extension MenuViewController: MenuViewInput, ErrorShowable {
    var delegate: UIViewController {
        return self
    }

    /// アラートを表示する。
    func throwError(_ error: Error) {
        self.showAlert(error: error)
    }
}
