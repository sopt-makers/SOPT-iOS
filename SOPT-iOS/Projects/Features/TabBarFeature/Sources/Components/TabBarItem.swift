
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

extension TabBarItemType {
    private var itemImage: UIImage {
        switch self {
        case .home:
            return DSKitAsset.Assets.icHomeFilled.image.withRenderingMode(.alwaysTemplate)
        case .soptlog:
            return DSKitAsset.Assets.icUserFilled.image.withRenderingMode(.alwaysTemplate)
        }
    }
    
    private var title: String {
        switch self {
        case .home:
            return I18N.Home.title
        case .soptlog:
            return I18N.Soptlog.tapTitle
        }
    }
    
    func makeTabBarItem() -> UITabBarItem {
        return UITabBarItem(title: self.title,
                            image: self.itemImage,
                            selectedImage: nil)
    }
}
