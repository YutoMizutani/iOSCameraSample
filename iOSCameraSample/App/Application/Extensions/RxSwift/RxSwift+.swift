//
//  RxSwift+.swift
//  iOSCameraSample
//
//  Created by YutoMizutani on 2018/06/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import RxSwift

public extension ObserverType where E == Void {
    public func onNext() {
        onNext(())
    }
}
