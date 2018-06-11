//
//  MenuTranslator.swift
//  iOSCameraSample
//
//  Created by Yuto Mizutani on 2018/6/11.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

protocol MenuTranslator {
    func translate(from model: MenuModel) -> MenuEntity
    func translate(from entity: MenuEntity) -> MenuModel
}

struct MenuTranslatorImpl: MenuTranslator {
    func translate(from model: MenuModel) -> MenuEntity {
        return MenuEntityImpl()
    }
    func translate(from entity: MenuEntity) -> MenuModel {
        return MenuModelImpl()
    }
}
