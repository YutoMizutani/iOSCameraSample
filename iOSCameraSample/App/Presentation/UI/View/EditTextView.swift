//
//  EditTextView.swift
//  iOSCameraSample
//
//  Created by YutoMizutani on 2018/06/14.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

class EditTextView: UIView {
    var fontSliderView: FontSliderView!
    var textView: UITextView!

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

extension EditTextView {
    private func configureView() {
        fontSliderView: do {
            self.fontSliderView = FontSliderView()
            self.fontSliderView.setRange((30, 100))
            self.addSubview(self.fontSliderView)
        }
        textView: do {
            self.textView = { () -> UITextView in
                let textView = UITextView()
                return textView
            }()
            self.addSubview(self.textView)
        }
    }
    private func layoutView() {
        fontSliderView: do {
            let height: CGFloat = 60
            self.fontSliderView.frame = CGRect(x: 0, y: self.safeAreaInsets.top, width: self.width, height: height)
        }
        textView: do {
            self.textView.frame = CGRect(x: 0, y: self.fontSliderView.frame.maxY, width: self.width, height: self.height - self.fontSliderView.height)
        }
    }
}
