//
//  EditTextView.swift
//  iOSCameraSample
//
//  Created by YutoMizutani on 2018/06/14.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

class EditTextView: UIView {
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
        textView: do {
            self.textView = UITextView()
            self.addSubview(self.textView)
        }
    }
    private func layoutView() {
        textView: do {
            self.textView.frame = self.frame
        }
    }
}
