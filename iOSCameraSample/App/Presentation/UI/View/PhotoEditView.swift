//
//  PhotoEditView.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoEditView: UIView {
    var imageView: UIImageView!
    var dismissButton: UIButton!

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
        dismissButton: do {
            self.dismissButton = { () -> UIButton in
                let button = UIButton()
                button.setTitle("×", for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 55)
                return button
            }()
            self.addSubview(self.dismissButton)
        }
    }

    private func layoutView() {
        imageView: do {
            // imageViewのframeを内部のimageサイズに合わせる。
            guard let image = self.imageView.image else { return }
            self.imageView.frame = AVMakeRect(aspectRatio: image.size, insideRect: self.bounds)
            self.imageView.center = self.center
        }
        dismissButton: do {
            let space: CGFloat = 15, length: CGFloat = 50
            self.dismissButton.frame = CGRect(x: space, y: self.aboveSpace + space, width: length, height: length)
        }
    }
}

extension PhotoEditView {
    /// imageViewに画像をセットする。
    public func inject(_ image: UIImage?) {
        self.imageView.image = image
    }
}
