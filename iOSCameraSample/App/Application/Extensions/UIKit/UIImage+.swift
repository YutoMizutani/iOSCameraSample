//
//  UIImage+.swift
//  iOSCameraSample
//
//  Created by YutoMizutani on 2018/06/14.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

extension UIImage {
    func resize(for _size: CGSize, opaque: Bool=false) -> UIImage? {
        let widthRatio = _size.width / self.size.width
        let heightRatio = _size.height / self.size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio

        let resizedSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)

        UIGraphicsBeginImageContextWithOptions(resizedSize, opaque, 0.0)
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }

    /// コントラストを適用する。
    func contrast(value: Float) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        let contrastCIImage = ciImage.applyColorControls([(CIColorControlsType.contrast, value)])
        let uiImage = CIContextInstance.shared.generate(from: contrastCIImage, orientation: self.imageOrientation)
        return uiImage
    }
}
