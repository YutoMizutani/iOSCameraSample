//
//  EditStampViewController.swift
//  iOSCameraSample
//
//  Created by YutoMizutani on 2018/06/17.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private let ItemIdentifier = "ItemIdentifier"

class EditStampViewController: UICollectionViewController {
    let flowLayout = StampFlowLayout()

    var sendImage = BehaviorRelay<UIImage?>(value: nil)
    private var onSelect: ((UIImage?) -> Void)? = nil

    convenience init(onSelect select: @escaping ((UIImage?) -> Void)) {
        self.init()
        self.onSelect = select
    }

    override func loadView() {
        configureCollectionView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /// collectionViewの数を返す。
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }

    /// collectionViewのCellを指定する。
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemIdentifier, for: indexPath) as! EditStampViewCell
        cell.imageView.image = PhotoEditCollectionItems.stamp(index: indexPath.item % 9)
        return cell
    }

    // 選択された際に呼ばれる。
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = PhotoEditCollectionItems.stamp(index: indexPath.item % 9)
        self.onSelect?(image)
        self.dismiss(animated: true, completion: nil)
    }
}

extension EditStampViewController {
    private func configureCollectionView() {
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        self.collectionView?.register(EditStampViewCell.self, forCellWithReuseIdentifier: ItemIdentifier)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self

        self.collectionView?.indicatorStyle = .white
    }

    private func configureView() {
        collection: do {
            self.flowLayout.invalidateLayout()
            self.collectionView?.setCollectionViewLayout(self.flowLayout, animated: true)
        }
        navigationItem: do {
            self.navigationItem.title = "スタンプ"
            let leftItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(self.cancel))
            leftItem.accessibilityIdentifier = "PhotoEditLeftBarButtonItem"
            self.navigationItem.leftBarButtonItem = leftItem
        }
    }

    /// NavigationBarの設定を行う。
    private func configureNavigationBar() {
        // 背景色
        self.navigationController?.navigationBar.barTintColor = .black
        // ボタン色
        self.navigationController?.navigationBar.tintColor = .white
        // タイトル色
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
    }
}

extension EditStampViewController {
    @objc private func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
}
