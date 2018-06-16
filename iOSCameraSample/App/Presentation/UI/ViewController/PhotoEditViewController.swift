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
    func presentAlert(title: String, message: String)
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureNavigationBar()
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
        navigationBar: do {
            let leftItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(self.dismissView))
            self.navigationItem.leftBarButtonItem = leftItem
        }
        toolbar: do {
            self.navigationController?.toolbar.barTintColor = .black
            // Toolbarの内容を指定する。
            let items: [UIBarButtonItem] = [
                UIBarButtonItem.flexibleSpace,
                UIBarButtonItem.empty,
                UIBarButtonItem.flexibleSpace,
                UIBarButtonItem(image: PhotoEditToolIcons.contrast, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.editContrast)),
                UIBarButtonItem.flexibleSpace,
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(self.showActivity)),
                UIBarButtonItem.flexibleSpace,
                UIBarButtonItem(image: PhotoEditToolIcons.text, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.addText)),
                UIBarButtonItem.flexibleSpace,
                UIBarButtonItem(image: PhotoEditToolIcons.stamp, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.addStamp)),
                UIBarButtonItem.flexibleSpace,
            ]
            items.filter{ $0.accessibilityIdentifier != UIBarButtonItem.empty.accessibilityIdentifier }.forEach{
                $0.tintColor = .white
            }
            self.toolbarItems = items
            self.navigationController?.setToolbarHidden(false, animated: false)
        }
    }
    /// NavigationBarの設定を行う。
    private func configureNavigationBar() {
        // 背景色
        self.navigationController?.navigationBar.barTintColor = .black
        // ボタン色
        self.navigationController?.navigationBar.tintColor = .white
        // タイトル色
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
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

            subview.contrastView.value
                .asObservable()
                .subscribe(onNext: { [weak self] value in
                    self?.presenter?.editContrast(value: value)
                })
                .disposed(by: disposeBag)
        }
    }
}

// >>> TODO:- rxで書き直す?
extension PhotoEditViewController {
    @objc private func dismissView() {
        self.presenter?.dismiss()
    }
    @objc private func showActivity() {
        if let image = self.translate() {
            self.presenter?.presentActivity(image: image)
        }
    }
    @objc private func addText() {
        self.presenter?.addText()
    }
    @objc private func editContrast(_ sender: UIBarButtonItem) {
        guard let subview = self.subview else { return }

        subview.contrastView.isHidden = !subview.contrastView.isHidden
        sender.tintColor = subview.contrastView.isHidden ? .white : self.view.tintColor
    }
    @objc private func addStamp() {

    }
}
// <<< rxで書き直す? MARK:-

extension PhotoEditViewController: PhotoEditViewInput, ErrorShowable {
    /// アラートを表示する。
    public func presentAlert(title: String, message: String) {
        self.presentAlert(title, message: message)
    }

    /// エラーアラートを表示する。
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

        // focusViewを初期化
        self.focusView.accept(nil)
        // textImageViewsのViewのレイヤーをself.viewからimageViewに切り換える。
        for view in subview.textImageViews.value {
            // textImageViewsのViewから，Labelのみの情報を取得する。
            let myview = view.duplicatedContentView

            // transform前の状態からサイズを変更する。
            let previousTransform = myview.transform
            myview.transform = .identity

            // imageViewのサイズに調整する。
            myview.frame = CGRect(x: myview.frame.minX - subview.imageView.frame.minX, y: myview.frame.minY - subview.imageView.frame.minY, width: myview.frame.width, height: myview.frame.height)

            // transform状態を戻す。
            myview.transform = previousTransform

            subview.imageView.addSubview(myview)
        }

        let image = subview.imageView.layerImage

        self.subview?.imageView.subviews.forEach { $0.removeFromSuperview() }

        return image
    }
}
