//
//  RxSwift+.swift
//  iOSCameraSample
//
//  Created by YutoMizutani on 2018/06/12.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive {
    /// 即時発火するObservable。
    static var immediate: Observable<Void> {
        return Observable<Void>.create { observer in
            observer.onNext()
            observer.onCompleted()
            return Disposables.create()
        }
    }
}

extension ObserverType where E == Void {
    func onNext() {
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
    var touchDown: ControlEvent<Void> {
        return controlEvent(.touchDown)
    }

    /// Reactive wrapper for `TouchUpInside` control event.
    var touchUpInside: ControlEvent<Void> {
        return controlEvent(.touchUpInside)
    }

    /// Reactive wrapper for `TouchCancel` control event.
    var touchCancel: ControlEvent<Void> {
        return controlEvent(.touchCancel)
    }

    /// Reactive wrapper for `TouchUpOutside` control event.
    var touchUpOutside: ControlEvent<Void> {
        return controlEvent(.touchUpOutside)
    }

    /// Reactive wrapper for `TouchDragOutside` control event.
    var touchDragOutside: ControlEvent<Void> {
        return controlEvent(.touchDragOutside)
    }

    /// Reactive wrapper for `TouchDragExit` control event.
    var touchDragExit: ControlEvent<Void> {
        return controlEvent(.touchDragExit)
    }

    /// Reactive wrapper for `AllEvents` control event.
    var allEvents: ControlEvent<Void> {
        return controlEvent(.allEvents)
    }
}

extension Reactive where Base: UIView {

    /// Bindable sink for `backgroundColor` property.
    var backgroundColor: Binder<UIColor?> {
        return Binder(self.base) { view, color in
            view.backgroundColor = color
        }
    }
}

extension Reactive where Base: UITableView {
    var isEditing: Binder<Bool> {
        return Binder(self.base) { tableView, isEditing in
            tableView.isEditing = isEditing
        }
    }
}

#endif
