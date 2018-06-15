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
    func addTextImageView(_ view: TextImageView)
}

protocol Focusable: class {
    var focusView: BehaviorRelay<UIView?> { get set }
}

class PhotoEditViewController: UIViewController {
    typealias presenterType = PhotoEditPresenter

    /// 最初に渡されるimage。
    private var rawImage: UIImage?
    private var image: BehaviorRelay<UIImage>?

    private var presenter: presenterType?
    private var subview: PhotoEditView?
    // tintColorの変更のためインスタンスに格納する。
    private var tools: (undo: UIBarButtonItem, redo: UIBarButtonItem)?

    // フォーカスされているViewを保持する。
    public var focusView: BehaviorRelay<UIView?> = BehaviorRelay(value: nil)

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

extension PhotoEditViewController: Focusable {
    private func binding() {
        if let subview = self.subview {
            subview.dismissButton.rx.tap
                .asObservable()
                .subscribe(onNext: { [weak self] _ in
                    self?.presenter?.dismiss()
                })
                .disposed(by: disposeBag)

            self.image = self.presenter?.getImageDisposable(self.rawImage)
            self.image?
                .asDriver(onErrorJustReturn: UIImage())
                .drive(subview.imageView.rx.image)
                .disposed(by: disposeBag)

            // textImageViewsが追加されたらaddSubViewする。
            subview.textImageViews.asObservable()
                .map{ $0.filter{ !$0.isDescendant(of: self.view) } }
                .subscribe(onNext: { [weak self] textImageViews in
                    textImageViews.forEach { [weak self] view in
                        if let _self = self {
                            view.center = _self.view.center
                            _self.subview?.layerView.addSubview(view)
                            view.binding({
                                _self.removeTextImageView(view)
                            })
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
        // TODO:
        if let image = self.translate() {
            self.image?.accept(image)
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
    public func addTextImageView(_ view: TextImageView) {
        guard let textImageViews = self.subview?.textImageViews else { return }
        var views = textImageViews.value
        views.append(view)
        textImageViews.accept(views)
    }

    /// TextImageViewを削除する。
    private func removeTextImageView(_ view: TextImageView) {
        guard let textImageViews = self.subview?.textImageViews else { return }
        // textImageViews保持の破棄
        let views = textImageViews.value.filter{ $0 != view }
        textImageViews.accept(views)

        // フォーカスの破棄
        if self.focusView.value == view {
            self.focusView.accept(nil)
        }
    }
}

extension PhotoEditViewController {
    private func translate() -> UIImage? {
        guard let subview = self.subview else { return nil }

        // textImageViewsのViewのレイヤーをself.viewからimageViewに切り換える。
        for view in subview.textImageViews.value {
            view.removeFromSuperview()
            let previousTransform = view.transform
            view.transform = .identity
            view.frame = CGRect(x: view.frame.minX - subview.imageView.frame.minX, y: view.frame.minY - subview.imageView.frame.minY, width: view.frame.width, height: view.frame.height)
            view.transform = previousTransform
            subview.imageView.addSubview(view)
        }
        // focusViewを初期化
        self.focusView.accept(nil)
        // textImageViewsを初期化
        subview.textImageViews.accept([])

        return subview.imageView.layerImage
    }
}
