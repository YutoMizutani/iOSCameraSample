//
//  TextImageView.swift
//  iOSCameraSample
//
//  Created by YutoMizutani on 2018/06/14.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class TextImageView: UIView {
    private var label: UILabel!
    private var contentText: BehaviorRelay<(String, UIFont?)> = BehaviorRelay(value: ("Text", nil))
    private var borderView: UIView!
    private var editButton: UIButton!
    private var deleteButton: UIButton!

    private var compositeDisposable = CompositeDisposable()

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureView()
        layoutView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layoutView()

        self.layoutIfNeeded()
    }
}

extension TextImageView {
    private func configureView() {
        view: do {
            self.backgroundColor = UIColor.clear
        }
        borderView: do {
            self.borderView = { () -> UIView in
                let view = UIView()
                view.layer.borderWidth = 0.5
                view.layer.borderColor = UIColor.white.cgColor
                return view
            }()
            self.addSubview(self.borderView)
        }
        label: do {
            self.label = { () -> UILabel in
                let label = UILabel()
                label.text = ""
                label.textColor = .white
                label.textAlignment = .left
                label.numberOfLines = 0
                label.lineBreakMode = .byWordWrapping
                label.font = UIFont.systemFont(ofSize: 44)
                return label
            }()
            self.addSubview(self.label)
        }
        editButton: do {
            self.editButton = { () -> UIButton in
                let button = UIButton()
                return button
            }()
            self.addSubview(self.editButton)
        }
        deleteButton: do {
            self.deleteButton = { () -> UIButton in
                let button = UIButton()
                button.setTitle("×", for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 44)
                button.backgroundColor = .white
                button.setTitleColor(.black, for: .normal)
                return button
            }()
            self.addSubview(self.deleteButton)
        }
    }

    private func layoutView() {
        DispatchQueue.main.async {
            // transformが初期状態ではない場合にframeを変更すると表示がずれるため，frameの変更は.identity下で行う。
            let previousTransform = self.transform
            self.transform = .identity
            // ボタンの長さ
            let length: CGFloat = 44
            label: do {
                let max = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
                let size = self.label.sizeThatFits(max)
                self.label.frame = CGRect(x: length/2, y: length/2, width: size.width, height: size.height)
                self.label.center = CGPoint(x: self.width/2, y: self.height/2)
            }
            view: do {
                // ラベルの自動整形によって大きさを変更する。
                self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: self.label.width + length, height: self.label.height + length)
            }
            borderView: do {
                self.borderView.frame = CGRect(x: length/2, y: length/2, width: self.label.width, height: self.label.height)
            }
            editButton: do {
                self.editButton.frame = self.label.frame
                self.editButton.center = self.label.center
            }
            deleteButton: do {
                self.deleteButton.layer.cornerRadius = length/2
                self.deleteButton.frame = CGRect(x: 0, y: 0, width: length, height: length)
            }
            self.transform = previousTransform
        }
    }
}

extension TextImageView {
    public func binding(_ completion: (() -> Void)?) {
        // Focus可能なViewControllerにaddSubViewされていれば，フォーカス状態に応じた処理を行う。
        if let parentViewController = self.parent as? Focusable {
            self.compositeDisposable.append(
                self.editButton.rx.touchDown
                    .asObservable()
                    .subscribe(onNext: { [weak self] _ in
                        parentViewController.focusView.accept(self)
                    })
            )
            parentViewController.focusView.accept(self)

            let sharedFocus = parentViewController.focusView
                .asObservable()
                .map{ $0 != self }
                .share(replay: 1)

            self.compositeDisposable.append(
                sharedFocus
                    .asDriver(onErrorJustReturn: false)
                    .drive(self.borderView.rx.isHidden)
            )

            self.compositeDisposable.append(
                sharedFocus
                    .asDriver(onErrorJustReturn: false)
                    .drive(self.deleteButton.rx.isHidden)
            )
        }

        label: do {
            let observableText = self.contentText.share(replay: 1)
            self.compositeDisposable.append(
                observableText
                    .asObservable()
                    .map{ $0.0 }
                    .map{ $0 == "" ? "Text" : $0 }
                    .asDriver(onErrorJustReturn: "Text")
                    .drive(self.label.rx.text)
            )
            self.compositeDisposable.append(
                observableText
                    .observeOn(MainScheduler.instance)
                    .map{ $0.1 }
                    .filter{ $0 != nil }.map{ $0! }
                    .subscribe(onNext: { font in
                        self.label.font = font
                    })
            )
        }
        transform: do {
            let transformGestures = self.rx.transformGestures().share(replay: 1)
            var previousTransform = CGAffineTransform.identity

            // 移動時に最前面に移動させる。
            self.compositeDisposable.append(
                transformGestures
                    .when(.began)
                    .asTransform()
                    .subscribe(onNext: { [weak self] _ in
                        guard let _self = self else { return }
                        guard let parentViewController = _self.parent else { return }
                        parentViewController.view.bringSubview(toFront: _self)
                    })
            )

            // 変形させる。
            self.compositeDisposable.append(
                transformGestures
                    .when(.changed)
                    .asTransform()
                    .subscribe(onNext: { [weak self] transform, _ in
                        guard let _self = self else { return }
                        _self.transform = previousTransform.rotated(by: transform.b).translatedBy(x: transform.tx, y: transform.ty)
                    })
            )

            // 前回の変形値を保存する。
            self.compositeDisposable.append(
                transformGestures
                    .when(.ended)
                    .asTransform()
                    .subscribe(onNext: { [weak self] _ in
                        guard let _self = self else { return }
                        previousTransform = _self.transform
                    })
            )
        }
        editButton: do {
            self.compositeDisposable.append(
                self.editButton.rx.tap
                    .asObservable()
                    .subscribe(onNext: { [weak self] _ in
                        let viewController = EditTextViewController()
                        viewController.navigationItem.title = "Edit text"
                        let text = self?.label.text, font = self?.label.font
                        if let content = text != nil ? (text!, font) : nil {
                            viewController.contentText.accept(content)
                        }
                        binding: do {
                            self?.compositeDisposable.append(
                                viewController.sendText
                                    .filter{ $0 != nil }.map{ $0! }
                                    .asObservable()
                                    .subscribe(onNext: { [weak self] text in
                                        self?.contentText.accept(text)
                                        self?.layoutView()
                                    })
                            )
                        }
                        let modalController = UINavigationController.init(rootViewController: viewController)
                        modalController.modalPresentationStyle = .overCurrentContext
                        self?.parent?.present(modalController, animated: true, completion: nil)
                    })
            )
        }
        deleteButton: do {
            // viewを削除する。
            self.compositeDisposable.append(
                self.deleteButton.rx.tap
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { [weak self] _ in
                        self?.removeFromSuperview()
                        self?.compositeDisposable.dispose()
                        completion?()
                    })
            )
        }
    }
}

extension TextImageView {
    /// 自身のUILabelのコンテンツのみ複製する。
    public var duplicatedContentView: UIView {
        // 新しいViewを作成する。
        let view = UIView()

        // transform前のViewからViewの情報を取得する。
        let previousTransform = self.transform
        self.transform = .identity
        view.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
        view.center = self.center

        // UILabelを複製する。
        if let duplicatedLabel: UILabel = self.label.duplicated as? UILabel {
            view.addSubview(duplicatedLabel)
        }

        // transform状態を反映する。
        self.transform = previousTransform
        view.transform = previousTransform

        return view
    }
}
