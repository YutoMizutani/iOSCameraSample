//
//  ErrorHandring.swift
//  iOSCameraSample
//
//  Created by YutoMizutani on 2018/06/11.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

fileprivate extension UIAlertController {
    static func present(_ delegate: UIViewController, message: String, actionTitle: String = "Cancel") {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .cancel) { _ -> Void in
        })

        DispatchQueue.main.async {
            delegate.present(alert, animated: true, completion: nil)
        }
    }
}

protocol ErrorShowable where Self: UIViewController {
    func showAlert(error: Error)
}

extension ErrorShowable {
    func showAlert(error: Error) {
        guard let error = error as? ErrorCameraUsage else {
            UIAlertController.present(self, message: "未定義のエラーが発生しました", actionTitle: "OK")
            return
        }

        switch error {
        case .unavailable:
            UIAlertController.present(self, message: "カメラが無効です。カメラが利用可能な状態か確認してください。")
            return
        case .permissionDenied:
            UIAlertController.present(self, message: "カメラを起動できません。設定アプリからカメラの使用許可を行ってください。")
            return
        case .permissionRestricted:
            UIAlertController.present(self, message: "カメラを起動できません。カメラへのアクセス制限を解除してください。")
            return
        case .failedCreateImage:
            UIAlertController.present(self, message: "イメージを生成できませんでした。もう一度お試しください。")
            return
        }
    }
}
