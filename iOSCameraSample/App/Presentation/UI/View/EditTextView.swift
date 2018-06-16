//
//  EditTextView.swift
//  iOSCameraSample
//
//  Created by YutoMizutani on 2018/06/14.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

class EditTextView: UIView {
    var sliderView: SliderView!
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
        sliderView: do {
            self.sliderView = SliderView(type: .integer)
            self.sliderView.setRange((30, 100))
            self.addSubview(self.sliderView)
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
        sliderView: do {
            let height: CGFloat = 60
            self.sliderView.frame = CGRect(x: 0, y: self.safeAreaInsets.top, width: self.width, height: height)
        }
        textView: do {
            self.textView.frame = CGRect(x: 0, y: self.sliderView.frame.maxY, width: self.width, height: self.height - self.sliderView.height)
        }
    }
}
