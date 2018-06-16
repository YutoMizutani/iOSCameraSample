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
    var layerView: UIView!

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
        layerView: do {
            self.layerView = UIView()
            self.addSubview(self.layerView)
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
    }
}
