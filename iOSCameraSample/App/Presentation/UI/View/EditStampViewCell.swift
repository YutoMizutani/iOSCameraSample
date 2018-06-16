//
//  EditStampViewCell.swift
//  iOSCameraSample
//
//  Created by YutoMizutani on 2018/06/17.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

class EditStampViewCell: UICollectionViewCell {
    var imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}

extension EditStampViewCell {
    private func configureView() {
        view: do {
            self.backgroundColor = UIColor.clear
            self.layer.borderColor = UIColor.white.cgColor
            self.layer.borderWidth = 0.2
        }
        imageView: do {
            self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height).insetBy(dx: 5, dy: 5))
            self.imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.contentView.addSubview(imageView)
        }
    }
}
