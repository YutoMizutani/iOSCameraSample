//
//  PhotoEditView.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation

class PhotoEditView: UIView {
    var imageView: UIImageView!
    var textImageViews: BehaviorRelay<[TextImageView]>!
    var stampImageViews: BehaviorRelay<[StampImageView]>!
    var resetFocusButton: UIButton!
    var layerView: UIView!
    var contrastView: SliderView!

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

extension PhotoEditView {
    private func configureView() {
        view: do {
            self.backgroundColor = UIColor.black
        }
        imageView: do {
            self.imageView = UIImageView()
            self.addSubview(self.imageView)
        }
        textImageViews: do {
            self.textImageViews = BehaviorRelay<[TextImageView]>(value: [])
        }
        stampImageViews: do {
            self.stampImageViews = BehaviorRelay<[StampImageView]>(value: [])
        }
        layerView: do {
            self.layerView = UIView()
            self.addSubview(self.layerView)
        }
        resetFocusButton: do {
            self.resetFocusButton = UIButton()
            self.layerView.addSubview(self.resetFocusButton)
        }
        contrastView: do {
            self.contrastView = SliderView(type: .digit(1))
            self.contrastView.isHidden = true
            self.contrastView.backgroundColor = UIColor(white: 0.8, alpha: 1)
            self.contrastView.setRange((0.5, 2))
            self.contrastView.value.accept(1)
            self.addSubview(self.contrastView)
        }
    }

    private func layoutView() {
        imageView: do {
            // imageViewのframeを内部のimageサイズに合わせる。
            guard let image = self.imageView.image else { return }
            self.imageView.frame = AVMakeRect(aspectRatio: image.size, insideRect: self.bounds)
            self.imageView.center = self.center
        }
        layerView: do {
            self.layerView.frame = self.frame
        }
        resetFocusButton: do {
            self.resetFocusButton.frame = self.layerView.frame
        }
        contrastView: do {
            let height: CGFloat = 60
            self.contrastView.frame = CGRect(x: 0, y: self.height - self.safeArea.bottom - height, width: self.width, height: height)
        }
    }
}
