//
//  StampImageView.swift
//  iOSCameraSample
//
//  Created by YutoMizutani on 2018/06/17.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class StampImageView: UIView {
    private var imageView: UIImageView!
    private var borderView: UIView!
    private var focusButton: UIButton!
    private var deleteButton: UIButton!

    private var scale = BehaviorRelay<CGFloat>(value: 1)

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

extension StampImageView {
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
        imageView: do {
            self.imageView = { () -> UIImageView in
                let imageView = UIImageView()
                return imageView
            }()
            self.addSubview(self.imageView)
        }
        focusButton: do {
            self.focusButton = { () -> UIButton in
                let button = UIButton()
                return button
            }()
            self.addSubview(self.focusButton)
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
            let buttonLength: CGFloat = 44
            let imageLength: CGFloat = 100 * self.scale.value
            imageView: do {
                self.imageView.frame = CGRect(x: 0, y: 0, width: imageLength, height: imageLength)
                // ラベルの自動整形によって大きさを変更する。
                self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: self.imageView.width + buttonLength, height: self.imageView.height + buttonLength)
                self.imageView.center = CGPoint(x: self.width/2, y: self.height/2)
            }
            borderView: do {
                self.borderView.frame = CGRect(x: buttonLength/2, y: buttonLength/2, width: self.imageView.width, height: self.imageView.height)
            }
            focusButton: do {
                self.focusButton.frame = self.imageView.frame
                self.focusButton.center = self.imageView.center
            }
            deleteButton: do {
                self.deleteButton.layer.cornerRadius = buttonLength/2
                self.deleteButton.frame = CGRect(x: 0, y: 0, width: buttonLength, height: buttonLength)
            }
            self.transform = previousTransform
        }
    }
}

extension StampImageView {
    func binding(_ completion: (() -> Void)?) {
        // Focus可能なViewControllerにaddSubViewされていれば，フォーカス状態に応じた処理を行う。
        if let parentViewController = self.parent as? Focusable {
            self.compositeDisposable.append(
                self.focusButton.rx.touchDown
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

        transform: do {
            let transformGestures = self.rx.transformGestures().share(replay: 1)
            var previousTransform = CGAffineTransform.identity
            var previousScale: CGFloat = 1

            // 移動時に最前面に移動させる。
            self.compositeDisposable.append(
                transformGestures
                    .when(.began)
                    .asTransform()
                    .subscribe(onNext: { [weak self] _ in
                        guard let _self = self else { return }
                        guard let parentViewController = _self.parent else { return }
                        let focusLayerView = (parentViewController as? Focusable)?.focusLayerView ?? parentViewController.view
                        focusLayerView?.bringSubview(toFront: _self)
                    })
            )

            // 変形させる。
            self.compositeDisposable.append(
                transformGestures
                    .when(.changed)
                    .asTransform()
                    .subscribe(onNext: { [weak self] transform, _ in
                        guard let _self = self else { return }
                        _self.scale.accept(transform.a * previousScale)
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
                        previousScale = _self.scale.value
                        previousTransform = _self.transform
                    })
            )

            self.compositeDisposable.append(
                self.scale
                    .asObservable()
                    .subscribe(onNext: { [weak self] _ in
                        self?.layoutView()
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

extension StampImageView {
    /// 自身のUILabelのコンテンツのみ複製する。
    var duplicatedContentView: UIView {
        // 新しいViewを作成する。
        let view = UIView()

        // transform前のViewからViewの情報を取得する。
        let previousTransform = self.transform
        self.transform = .identity
        view.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
        view.center = self.center

        // UIImageViewを複製する。
        if let duplicatedImageView: UIImageView = self.imageView.duplicated as? UIImageView {
            duplicatedImageView.image = self.imageView.image
            view.addSubview(duplicatedImageView)
        }

        // transform状態を反映する。
        self.transform = previousTransform
        view.transform = previousTransform

        return view
    }
}

extension StampImageView {
    func inject(_ image: UIImage?) {
        self.imageView.image = image
    }
}
