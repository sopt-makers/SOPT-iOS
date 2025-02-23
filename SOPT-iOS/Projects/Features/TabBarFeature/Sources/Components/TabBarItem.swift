
//
//  TabBarItem.swift
//  TabBarFeature
//
//  Created by 강윤서 on 2/20/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import DSKit

enum TabBarItem: Int, CaseIterable {
    case home, soptlog
    
    private var itemImage: UIImage {
        switch self {
        case .home:
            return DSKitAsset.Assets.icHomeFilled.image.withRenderingMode(.alwaysTemplate)
        case .soptlog:
            return DSKitAsset.Assets.icUserFilled.image.withRenderingMode(.alwaysTemplate)
        }
    }
}

extension TabBarItem {
    func makeTabBarItem() -> UITabBarItem {
        return UITabBarItem(title: nil,
                            image: self.itemImage,
                            selectedImage: nil)
    }
}
