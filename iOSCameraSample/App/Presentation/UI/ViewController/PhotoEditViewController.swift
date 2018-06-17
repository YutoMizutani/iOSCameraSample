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
    func addStampImageView(_ view: StampImageView)
}

protocol Focusable: class {
    var focusView: BehaviorRelay<UIView?> { get set }
    var focusLayerView: UIView? { get }
}

class PhotoEditViewController: UIViewController {
    typealias presenterType = PhotoEditPresenter

    /// 最初に渡されるimage。
    private var rawImage: UIImage?
    private var image: BehaviorRelay<UIImage>?

    private var presenter: presenterType?
    private var subview: PhotoEditView?

    // フォーカスされているViewを保持する。
    var focusView: BehaviorRelay<UIView?> = BehaviorRelay(value: nil)

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
        view: do {
            self.view.backgroundColor = UIColor.white
        }
        subview: do {
            self.subview = PhotoEditView()
            if self.subview != nil {
                self.view.addSubview(self.subview!)
            }
        }
        navigationBar: do {
            self.navigationItem.title = "画像の編集"
            let leftItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(self.dismissView))
            leftItem.accessibilityIdentifier = "PhotoEditLeftBarButtonItem"
            self.navigationItem.leftBarButtonItem = leftItem
        }
        toolbar: do {
            let contrastButton = UIBarButtonItem(image: PhotoEditToolIcons.contrast, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.editContrast))
            contrastButton.accessibilityIdentifier = "contrastButton"
            let activityButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(self.showActivity))
            activityButton.accessibilityIdentifier = "activityButton"
            let textButton = UIBarButtonItem(image: PhotoEditToolIcons.text, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.addText))
            textButton.accessibilityIdentifier = "textButton"
            let stampButton = UIBarButtonItem(image: PhotoEditToolIcons.stamp, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.addStamp))
            stampButton.accessibilityIdentifier = "stampButton"
            // Toolbarの内容を指定する。
            let items: [UIBarButtonItem] = [
                UIBarButtonItem.flexibleSpace,
                UIBarButtonItem.empty,
                UIBarButtonItem.flexibleSpace,
                contrastButton,
                UIBarButtonItem.flexibleSpace,
                activityButton,
                UIBarButtonItem.flexibleSpace,
                textButton,
                UIBarButtonItem.flexibleSpace,
                stampButton,
                UIBarButtonItem.flexibleSpace,
            ]
            items.filter{ $0.accessibilityIdentifier != UIBarButtonItem.empty.accessibilityIdentifier }.forEach{
                $0.tintColor = .white
            }
            self.navigationController?.toolbar.barTintColor = .black
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
    var focusLayerView: UIView? {
        return self.subview?.layerView
    }

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

            // stampImageViewsが追加されたらaddSubViewする。
            subview.stampImageViews.asObservable()
                .map{ $0.filter{ !$0.isDescendant(of: self.view) } }
                .subscribe(onNext: { [weak self] stampImageViews in
                    stampImageViews.forEach { [weak self] view in
                        if let _self = self {
                            view.center = _self.view.center
                            _self.subview?.layerView.addSubview(view)
                            view.binding({
                                _self.removeStampImageView(view)
                            })
                        }
                    }
                })
                .disposed(by: disposeBag)

            // コントラストバーの値の変更を元にコントラストを変更する。
            subview.contrastView.value
                .asObservable()
                .subscribe(onNext: { [weak self] value in
                    self?.presenter?.editContrast(value: value)
                })
                .disposed(by: disposeBag)

            // コンテンツ以外のフィールドへのタップによりフォーカスを解除する。
            subview.resetFocusButton.rx.tap
                .asObservable()
                .subscribe(onNext: { [weak self] _ in
                    self?.focusView.accept(nil)
                })
                .disposed(by: disposeBag)
        }
    }
}

extension PhotoEditViewController {
    @objc private func dismissView() {
        self.presenter?.dismiss()
    }
    @objc private func showActivity() {
        if let image = self.translate() {
            // 変換したイメージを元にActivityを表示する。
            self.presenter?.presentActivity(image: image)
        }
    }
    @objc private func addText() {
        // テキストを追加する。
        self.presenter?.addText()
    }
    @objc private func editContrast(_ sender: UIBarButtonItem) {
        guard let subview = self.subview else { return }

        // コントラストViewの表示を切り換える。
        subview.contrastView.isHidden = !subview.contrastView.isHidden
        sender.tintColor = subview.contrastView.isHidden ? .white : self.view.tintColor
    }
    @objc private func addStamp() {
        // スタンプを表示する。
        self.presenter?.addStamp()
    }
}

extension PhotoEditViewController: PhotoEditViewInput, ErrorShowable {
    /// アラートを表示する。
    func presentAlert(title: String, message: String) {
        self.presentAlert(title, message: message)
    }

    /// エラーアラートを表示する。
    func throwError(_ error: Error) {
        self.showAlert(error: error)
    }

    /// 選択可能なアラートを表示する。
    func presentSelect(_ model: PhotoEditAlertModel) {
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

    /// StampImageViewを追加する。
    func addStampImageView(_ view: StampImageView) {
        guard let stampImageViews = self.subview?.stampImageViews else { return }
        var views = stampImageViews.value
        views.append(view)
        stampImageViews.accept(views)
    }

    /// TextImageViewを削除する。
    private func removeStampImageView(_ view: StampImageView) {
        guard let stampImageViews = self.subview?.stampImageViews else { return }
        // textImageViews保持の破棄
        let views = stampImageViews.value.filter{ $0 != view }
        stampImageViews.accept(views)

        // フォーカスの破棄
        if self.focusView.value == view {
            self.focusView.accept(nil)
        }
    }
}

extension PhotoEditViewController {
    /// imageViewから画像を作成する。
    private func translate() -> UIImage? {
        guard let subview = self.subview else { return nil }

        // focusViewを初期化
        self.focusView.accept(nil)

        for view in subview.layerView.subviews {
            // imageViewに追加するコンテンツをlayerViewから抽出する。
            var duplicatedContentView: UIView? = nil
            if let textImageView = view as? TextImageView {
                // textImageViewsのViewから，Labelのみの情報を取得する。
                duplicatedContentView = textImageView.duplicatedContentView
            }else if let stampImageView = view as? StampImageView {
                // textImageViewsのViewから，Labelのみの情報を取得する。
                duplicatedContentView = stampImageView.duplicatedContentView
            }

            guard let myview = duplicatedContentView else { continue }

            // transform前の状態からサイズを変更する。
            let previousTransform = myview.transform
            myview.transform = .identity
            // imageViewのサイズに調整する。
            myview.frame = CGRect(x: myview.frame.minX - subview.imageView.frame.minX, y: myview.frame.minY - subview.imageView.frame.minY, width: myview.frame.width, height: myview.frame.height)
            // transform状態を戻す。
            myview.transform = previousTransform
            // image作成用にimageViewに追加する。
            subview.imageView.addSubview(myview)
        }

        // imageView内の表示を元にUIImageを作成する。
        let image: UIImage = subview.imageView.layerImage

        // imageView内に作成したviewを開放する。
        self.subview?.imageView.subviews.forEach { $0.removeFromSuperview() }

        return image
    }
}
