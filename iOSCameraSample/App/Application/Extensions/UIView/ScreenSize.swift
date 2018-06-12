//
//  ScreenSize.swift
//  iOSCameraSample
//
//  Created by YutoMizutani on 2018/06/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

extension UIViewController {
    var bounds: CGRect {
        return UIScreen.main.bounds
    }
    var size: CGSize {
        return UIScreen.main.bounds.size
    }
    var height: CGFloat {
        return self.size.height
    }
    var width: CGFloat {
        return self.size.width
    }
    var long: CGFloat {
        let size = self.size
        return size.height > size.width ? size.height : size.width
    }
    var short: CGFloat {
        let size = self.size
        return size.height > size.width ? size.width : size.height
    }
}

extension UIView {
    var size: CGSize {
        return self.bounds.size
    }
    var height: CGFloat {
        return self.size.height
    }
    var width: CGFloat {
        return self.size.width
    }
    var long: CGFloat {
        let size = self.size
        return size.height > size.width ? size.height : size.width
    }
    var short: CGFloat {
        let size = self.size
        return size.height > size.width ? size.width : size.height
    }
    var isPortrait: Bool {
        return self.height >= self.width
    }
    var safeArea: UIEdgeInsets {
        let safeAreaInsets: UIEdgeInsets
        if #available(iOS 11, *) {
            safeAreaInsets = self.safeAreaInsets
        } else {
            safeAreaInsets = .zero
        }
        return safeAreaInsets
    }
}
