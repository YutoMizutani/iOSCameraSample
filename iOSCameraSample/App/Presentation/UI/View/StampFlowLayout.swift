//
//  StampFlowLayout.swift
//  iOSCameraSample
//
//  Created by YutoMizutani on 2018/06/17.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

class StampFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()

        self.itemSize = CGSize(width: 75, height: 75)
        self.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.minimumInteritemSpacing = 10.0
        self.minimumLineSpacing = 10.0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
