//
//  SliderView.swift
//  iOSCameraSample
//
//  Created by YutoMizutani on 2018/06/16.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum SliderLabelType {
    case integer
    case digit(Int)
}

class SliderView: UIView {
    private var slider: UISlider!
    private var label: UILabel!

    private var range: (min: Float, max: Float) = (0, 1)
    public var value = BehaviorRelay<Float>(value: 0)
    private var labelType: SliderLabelType = .integer

    let disposeBag = DisposeBag()

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    convenience init(type: SliderLabelType) {
        self.init()
        self.labelType = type
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureView()
        layoutView()
        binding()
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        layoutView()

        self.layoutIfNeeded()
    }
}

extension SliderView {
    private func configureView() {
        view: do {
            self.backgroundColor = UIColor(white: 0, alpha: 0.1)
        }
        slider: do {
            self.slider = { () -> UISlider in
                let slider = UISlider()

                return slider
            }()
            self.addSubview(self.slider)
        }
        label: do {
            self.label = { () -> UILabel in
                let label = UILabel()
                label.textAlignment = .left
                label.font = UIFont.systemFont(ofSize: 20)

                return label
            }()
            self.addSubview(self.label)
        }
    }
    private func layoutView() {
        let length: CGFloat = 75
        label: do {
            self.label.frame = CGRect(x: 0, y: 0, width: length, height: self.height)
            self.label.center = CGPoint(x: self.width*9/10, y: self.height/2)
        }
        slider: do {
            self.slider.frame = CGRect(x: 0, y: 0, width: self.width*7/10, height: self.height)
            self.slider.center = CGPoint(x: (self.width - self.label.width)/2, y: self.height/2)
        }
    }
}

extension SliderView {
    private func binding() {
        self.slider.rx.value
            .asObservable()
            .map{ self.range.min + (self.range.max - self.range.min) * $0 }
            .bind(to: self.value)
            .disposed(by: disposeBag)

        let valueObservable = self.value.share(replay: 1)
        valueObservable
            .asObservable()
            .map{
                switch self.labelType {
                case .integer:
                    return "\(Int($0))"
                case .digit(let value):
                    let d = pow(10, Float(value))
                    return "\(Float(Int($0*d))/d)"
                }
            }
            .asDriver(onErrorJustReturn: "")
            .drive(self.label.rx.text)
            .disposed(by: disposeBag)

        valueObservable
            .asObservable()
            .map{ Float($0 - self.range.min) / Float(self.range.max - self.range.min) }
            .asDriver(onErrorJustReturn: 0)
            .drive(self.slider.rx.value)
            .disposed(by: disposeBag)
    }
}

extension SliderView {
    public func setRange(_ range: (min: Float, max: Float)) {
        self.range = range
    }
}
