//
//  TextImageView.swift
//  iOSCameraSample
//
//  Created by YutoMizutani on 2018/06/14.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

class TextImageView: UIView {
    var label: UILabel!
    var deleteButton: UIButton!
    var editButton: UIButton!

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

extension TextImageView {
    private func configureView() {
        view: do {
            self.backgroundColor = UIColor.clear
            self.layer.borderWidth = 0.4
            self.layer.borderColor = UIColor.white.cgColor
        }
        label: do {
            self.label = { () -> UILabel in
                let label = UILabel()
                label.text = "Text"
                label.textColor = .white
                label.textAlignment = .center
                label.numberOfLines = 0
                label.adjustsFontSizeToFitWidth = true
                return label
            }()
            self.addSubview(self.label)
        }
        deleteButton: do {
            self.deleteButton = { () -> UIButton in
                let button = UIButton()
                button.setTitle("×", for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 44)
                return button
            }()
            self.addSubview(self.deleteButton)
        }
        editButton: do {
            self.editButton = { () -> UIButton in
                let button = UIButton()
                button.setTitle("×", for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 44)
                return button
            }()
            self.addSubview(self.editButton)
        }
    }

    private func layoutView() {
        label: do {
            self.label.frame = self.bounds
        }
    }
}
