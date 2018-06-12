//
//  PhotoEditViewController.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol PhotoEditViewInput: class {

}


class PhotoEditViewController: UIViewController {
    typealias presenterType = PhotoEditPresenter

    private var image: UIImage?

    private var presenter: presenterType?
    private var subview: PhotoEditView?

    private let disposeBag = DisposeBag()

    internal func inject(
        presenter: presenterType,
        image: UIImage
        ) {
        self.presenter = presenter
        self.image = image
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

extension PhotoEditViewController {
    private func configureView() {
        selfview: do {
            self.view.backgroundColor = UIColor.white
        }
        subview: do {
            self.subview = PhotoEditView(frame: self.view.bounds)
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

extension PhotoEditViewController {
    private func binding() {

    }
}

extension PhotoEditViewController: PhotoEditViewInput {

}
