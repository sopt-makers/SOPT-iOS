
//
//  TabBarItem.swift
//  TabBarFeature
//
//  Created by 강윤서 on 2/20/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit
import MDS

extension TabBarItemType {
    private var itemImage: UIImage {
        switch self {
        case .home:
            return MDSIcon.homeFilled.image.withRenderingMode(.alwaysTemplate)
        case .soptamp:
            return DSKitAsset.Assets.icSoptampFilled.image.withRenderingMode(.alwaysTemplate)
        case .poke:
            return DSKitAsset.Assets.icPokeFilled.image.withRenderingMode(.alwaysTemplate)
        case .mypage:
            return MDSIcon.userFilled.image.withRenderingMode(.alwaysTemplate)
        }
    }
    
    private var title: String {
        switch self {
        case .home:
            return I18N.Home.title
        case .soptamp:
            return I18N.Soptamp.title
        case .poke:
            return I18N.Poke.title
        case .mypage:
            return I18N.MyPage.title
        }
    }
    
    func makeTabBarItem() -> UITabBarItem {
        return UITabBarItem(title: self.title,
                            image: self.itemImage,
                            selectedImage: nil)
    }
}
