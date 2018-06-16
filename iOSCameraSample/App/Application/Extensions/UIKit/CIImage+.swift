//
//  CIImage+.swift
//  iOSCameraSample
//
//  Created by YutoMizutani on 2018/06/16.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

public enum CIFilterType: String {
    case sepiaTone = "CISepiaTone"
    case colorControls = "CIColorControls"
}

protocol CIFiltable {
}

public enum CISepiaToneType: String, CIFiltable {
    case intensity = "inputIntensity"
}

public enum CIColorControlsType: String, CIFiltable {
    case saturation = "inputSaturation"
    case brightness = "inputBrightness"
    case contrast = "inputContrast"
}

extension CIImage {
    func applySepiaToneType(_ parameters: [(CISepiaToneType, Any)]) -> CIImage {
        var collection = [String : Any]()
        parameters.forEach{
            collection[$0.0.rawValue] = $0.1
        }

        return self.applyingFilter(CIFilterType.sepiaTone.rawValue, parameters: collection)
    }
    
    func applyColorControls(_ parameters: [(CIColorControlsType, Any)]) -> CIImage {
        var collection = [String : Any]()
        parameters.forEach{
            collection[$0.0.rawValue] = $0.1
        }

        return self.applyingFilter(CIFilterType.colorControls.rawValue, parameters: collection)
    }
}

/// 生成に時間がかかるCIContextのシングルトンクラス
class CIContextInstance {
    /// singleton instance
    static let shared = CIContextInstance()

    // variable
    private let ciContext: CIContext

    private init() {
        self.ciContext = CIContext(options: nil)
    }

    /// CIImageからUIImageに変換する。
    public func generate(from image: CIImage, orientation: UIImageOrientation) -> UIImage? {
        guard let cgImage: CGImage = self.ciContext.createCGImage(image, from: image.extent) else { return nil }

        return UIImage(cgImage: cgImage, scale: 0, orientation: orientation)
    }
}
