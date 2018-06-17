//
//  EditTextViewController.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/14.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol EditTextViewInput: class {
    func inject(_ value: (String, UIFont?)?)
}

class EditTextViewController: UIViewController {
    private var subview: EditTextView!
    var contentText: BehaviorRelay<(String, UIFont?)?> = BehaviorRelay(value: nil)
    var sendText: BehaviorRelay<(String, UIFont?)?> = BehaviorRelay(value: nil)

    private let disposeBag = DisposeBag()

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

extension EditTextViewController {
    private func configureView() {
        view: do {
            self.view.backgroundColor = UIColor.white
        }
        subview: do {
            self.subview = EditTextView()
            if self.subview != nil {
                self.view.addSubview(self.subview!)
            }
        }
        navigationItem: do {
            let leftButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(self.cancel))
            self.navigationItem.leftBarButtonItem = leftButton

            let rightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.done))
            self.navigationItem.rightBarButtonItem = rightButton
        }
    }
    private func layoutView() {
        view: do {
            self.navigationItem.title = "文字の編集"
        }
        subview: do {
            self.subview?.frame = self.view.bounds
        }
    }
}

extension EditTextViewController {
    private func binding() {
        let observableContent = self.contentText.filter{ $0 != nil }.map{ $0! }.share(replay: 1)

        observableContent
            .asObservable()
            .map{ $0.0 }
            .asDriver(onErrorJustReturn: "")
            .drive(self.subview.textView.rx.text)
            .disposed(by: disposeBag)

        observableContent
            .asObservable()
            .map{ $0.1?.pointSize }
            .filter{ $0 != nil }.map{ $0! }
            .map{ Float($0) }
            .subscribe(onNext: { [weak self] value in
                self?.subview.sliderView.value.accept(value)
            })
            .disposed(by: disposeBag)

        self.subview.sliderView.value
            .asObservable()
            .subscribe(onNext: { [weak self] value in
                self?.subview.textView.font = UIFont.systemFont(ofSize: CGFloat(value))
            })
            .disposed(by: disposeBag)
    }
}

extension EditTextViewController {
    @objc private func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc private func done() {
        self.sendText.accept((self.subview.textView.text, self.subview.textView.font))
        self.dismiss(animated: true, completion: nil)
    }
}

extension EditTextViewController: EditTextViewInput {
    func inject(_ value: (String, UIFont?)?) {
        self.contentText.accept(value)
    }
}
