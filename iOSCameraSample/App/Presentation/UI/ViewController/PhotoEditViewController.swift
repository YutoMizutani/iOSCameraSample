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
import RxGesture

protocol PhotoEditViewInput: class {
    func throwError(_ error: Error)
    func presentSelect(_ model: PhotoEditAlertModel)
    func addTextImageView(_ view: TextImageView)
}


class PhotoEditViewController: UIViewController {
    typealias presenterType = PhotoEditPresenter

    /// 最初に渡されるimage。
    private var rawImage: UIImage?

    private var presenter: presenterType?
    private var subview: PhotoEditView?
    private var textImageViews: BehaviorRelay<[TextImageView]>!
    // tintColorの変更のためインスタンスに格納する。
    private var tools: (undo: UIBarButtonItem, redo: UIBarButtonItem)?

    private let disposeBag = DisposeBag()

    internal func inject(
        presenter: presenterType,
        image: UIImage
        ) {
        self.presenter = presenter
        self.rawImage = image
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
        textImageViews: do {
            self.textImageViews = BehaviorRelay<[TextImageView]>(value: [])
        }
        toolbar: do {
            // Toolbarの内容を指定する。
            let undo = UIBarButtonItem(barButtonHiddenItem: .back, target: self, action: #selector(self.undo))
            let redo = UIBarButtonItem(barButtonHiddenItem: .forward, target: self, action: #selector(self.redo))
            self.tools = (undo, redo)
            self.tools?.undo.isEnabled = false
            self.tools?.redo.isEnabled = false
            let items: [UIBarButtonItem] = [
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil),
                self.tools!.undo,
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
                self.tools!.redo,
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(self.showActivity)),
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(image: PhotoEditToolIcons.text, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.addText)),
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(image: PhotoEditToolIcons.contrast, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.editContrast)),
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil),
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
        if let subview = self.subview {
            subview.dismissButton.rx.tap
                .asObservable()
                .subscribe(onNext: { [weak self] _ in
                    self?.presenter?.dismiss()
                })
                .disposed(by: disposeBag)

            self.presenter?.getImageDisposable(self.rawImage)?
                .asDriver(onErrorJustReturn: UIImage())
                .drive(subview.imageView.rx.image)
                .disposed(by: disposeBag)
        }
        textImageViews: do {
            // textImageViewsが追加されたらaddSubViewする。
            self.textImageViews.asObservable()
                .map{ $0.filter{ !$0.isDescendant(of: self.view) } }
                .subscribe(onNext: { [weak self] textImageViews in
                    if let _self = self {
                        textImageViews.forEach {
                            $0.center = _self.view.center
                            _self.view.addSubview($0)
                            $0.binding(by: _self.disposeBag)
                        }
                    }
                })
                .disposed(by: disposeBag)
        }
    }
}

// >>> TODO:- rxで書き直す?
extension PhotoEditViewController {
    @objc private func undo() {

    }
    @objc private func redo() {

    }
    @objc private func showActivity() {
        if let image = self.subview?.imageView.image {
            self.presenter?.presentActivity(image: image)
        }
    }
    @objc private func addText() {
        self.presenter?.addText()
    }
    @objc private func editContrast() {

    }
}
// <<< rxで書き直す? MARK:-

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

    /// TextImageViewを追加する。
    func addTextImageView(_ view: TextImageView) {
        var views = self.textImageViews.value
        views.append(view)
        self.textImageViews.accept(views)
    }
}
