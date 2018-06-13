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
    func throwError(_ error: Error)
    func presentSelect(_ model: PhotoEditAlertModel)
}


class PhotoEditViewController: UIViewController {
    typealias presenterType = PhotoEditPresenter

    private var image: UIImage?

    private var presenter: presenterType?
    private var subview: PhotoEditView?
    // tintColorの変更のためインスタンスに格納する。
    private var tools: (undo: UIBarButtonItem, redo: UIBarButtonItem)?

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
                self.subview!.inject(self.image)
                self.view.addSubview(self.subview!)
            }
        }
        toolbar: do {
            // Toolbarの内容を指定する。
            let undo = UIBarButtonItem(barButtonHiddenItem: .back, target: self, action: #selector(self.undo))
            let redo = UIBarButtonItem(barButtonHiddenItem: .forward, target: self, action: #selector(self.redo))
            self.tools = (undo, redo)
            let items: [UIBarButtonItem] = [
                self.tools!.undo,
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
                self.tools!.redo,
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(self.showActivity)),
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            ]
            self.toolbarItems = items
            self.navigationController?.setToolbarHidden(false, animated: false)
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
        self.subview?.dismissButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.presenter?.dismiss()
            })
            .disposed(by: disposeBag)
    }
}

extension PhotoEditViewController {
    @objc private func undo() {

    }
    @objc private func redo() {

    }
    @objc private func showActivity() {

    }
}

extension PhotoEditViewController: PhotoEditViewInput, ErrorShowable {
    /// アラートを表示する。
    public func throwError(_ error: Error) {
        self.showAlert(error: error)
    }

    /// 選択可能なアラートを表示する。
    public func presentSelect(_ model: PhotoEditAlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: model.done.0, style: .default) { _ -> Void in
            model.done.1()
        })
        alert.addAction(UIAlertAction(title: model.cancel.0, style: .cancel) { _ -> Void in
            model.cancel.1?() ?? ()
        })

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
