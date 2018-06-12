//
//  PhotoEditView.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

class PhotoEditView: UIView {
    var imageView: UIImageView!

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
        self.imageView = UIImageView()
        self.addSubview(self.imageView)
    }
    private func layoutView() {
        self.imageView?.frame = self.frame
    }
}

extension PhotoEditView {
    /// imageViewに画像をセットする。
    public func inject(_ image: UIImage?) {
        self.imageView.image = image
    }
}
