//
//  RxSwift+.swift
//  iOSCameraSample
//
//  Created by YutoMizutani on 2018/06/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import RxSwift
import RxCocoa

public extension Reactive {
    /// 即時発火するObservable。
    static var immediate: Observable<Void> {
        return Observable<Void>.create { observer in
            observer.onNext()
            observer.onCompleted()
            return Disposables.create()
        }
    }
}

public extension ObserverType where E == Void {
    public func onNext() {
        onNext(())
    }
}

extension CompositeDisposable {
    func append(_ disposable: Disposable) {
        _ = self.insert(disposable)
    }
    func append(_ optionalDisposable: Disposable?) {
        if let disposable: Disposable = optionalDisposable {
            self.append(disposable)
        }
    }
}

#if os(iOS)

import UIKit

extension Reactive where Base: UIButton {

    /// Reactive wrapper for `TouchDown` control event.
    public var touchDown: ControlEvent<Void> {
        return controlEvent(.touchDown)
    }

    /// Reactive wrapper for `TouchUpInside` control event.
    public var touchUpInside: ControlEvent<Void> {
        return controlEvent(.touchUpInside)
    }
}

extension Reactive where Base: UIView {

    /// Bindable sink for `backgroundColor` property.
    public var backgroundColor: Binder<UIColor?> {
        return Binder(self.base) { view, color in
            view.backgroundColor = color
        }
    }
}

extension Reactive where Base: UITableView {
    public var isEditing: Binder<Bool> {
        return Binder(self.base) { tableView, isEditing in
            tableView.isEditing = isEditing
        }
    }
}

#endif
