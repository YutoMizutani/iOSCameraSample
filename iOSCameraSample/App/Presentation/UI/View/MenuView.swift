//
//  MenuView.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/11.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

class MenuView: UIView {
    var launchCameraButton: UIButton!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureView()
        layoutView()
    }

    /// 画面が更新された際に呼ばれる。この変更はこのクラスからは呼ばず，利用しているViewControllerから呼ぶようにする。
    override func layoutSubviews() {
        super.layoutSubviews()

        layoutView()
        
        self.layoutIfNeeded()
    }
}

extension MenuView {
    /// Viewを設定する。
    private func configureView() {
        launchCameraButton: do {
            self.launchCameraButton = { () -> UIButton in
                let button = UIButton()
                // タイトル
                button.setTitle("Launch camera", for: .normal)
                // 文字色
                button.setTitleColor(UIColor(red: 0, green: 0, blue: 1, alpha: 1), for: .normal)
                button.setTitleColor(UIColor(red: 0, green: 0, blue: 1, alpha: 0.2), for: .highlighted)
                // フォント
                button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
                // テスト用の識別子
                button.accessibilityIdentifier = "launchCameraButton"
                return button
            }()
            self.addSubview(self.launchCameraButton)
        }
    }

    /// 画面が更新された際に呼ばれる。
    private func layoutView() {
        launchCameraButton: do {
            self.launchCameraButton.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
            self.launchCameraButton.center = self.center
        }
    }
}
