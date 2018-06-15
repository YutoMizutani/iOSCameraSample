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
    var label: UILabel!
    var contentText: BehaviorRelay<String> = BehaviorRelay(value: "Text")
    var borderView: UIView!
    var editButton: UIButton!
    var deleteButton: UIButton!

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
                label.textAlignment = .center
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
//                button.backgroundColor = .red
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
        }
    }
}

extension TextImageView {
    public func binding(by disposeBag: DisposeBag, completion: (() -> Void)?) {
        label: do {
            self.contentText
                .map{ $0 == "" ? "Text" : $0 }
                .asDriver(onErrorJustReturn: "Text")
                .drive(self.label.rx.text)
                .disposed(by: disposeBag)
        }
        transform: do {
            let transformGestures = self.rx.transformGestures().share(replay: 1)
            var previousTransform = CGAffineTransform.identity

            // 移動時に最前面に移動させる。
            transformGestures
                .when(.began)
                .asTransform()
                .subscribe(onNext: { [weak self] _ in
                    guard let _self = self else { return }
                    guard let parentViewController = _self.parent else { return }
                    parentViewController.view.bringSubview(toFront: _self)
                })
                .disposed(by: disposeBag)

            // 変形させる。
            transformGestures
                .when(.changed)
                .asTransform()
                .subscribe(onNext: { [weak self] transform, _ in
                    guard let _self = self else { return }
                    _self.transform = previousTransform.rotated(by: transform.b).translatedBy(x: transform.tx, y: transform.ty)
                })
                .disposed(by: disposeBag)

            // 前回の変形値を保存する。
            transformGestures
                .when(.ended)
                .asTransform()
                .subscribe(onNext: { [weak self] _ in
                    guard let _self = self else { return }
                    previousTransform = _self.transform
                })
                .disposed(by: disposeBag)
        }
        editButton: do {
            self.editButton.rx.tap
                .asObservable()
                .subscribe(onNext: { [weak self] _ in
                    let viewController: EditTextViewController = EditTextViewController()
                    viewController.navigationItem.title = "Edit text"
                    binding: do {
                        viewController.sendText
                            .filter{ $0 != nil }.map{ $0! }
                            .asObservable()
                            .subscribe(onNext: { [weak self] text in
                                print("sendSignal")
                                self?.contentText.accept(text)
                                self?.layoutView()
                            })
                            .disposed(by: disposeBag)
                    }
                    let modalController = UINavigationController.init(rootViewController: viewController)
                    modalController.modalPresentationStyle = .overCurrentContext
                    self?.parent?.present(modalController, animated: true, completion: nil)
                })
                .disposed(by: disposeBag)
        }
        deleteButton: do {
            // viewを削除する。
            self.deleteButton.rx.tap
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] _ in
                    self?.removeFromSuperview()
                    completion?()
                })
                .disposed(by: disposeBag)
        }
    }
}
