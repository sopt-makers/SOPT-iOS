//
//  TabBarMenuSection.swift
//  TabBarFeature
//
//  Created by 강윤서 on 4/14/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import UIKit

import Core
import DSKit


struct MenuSectionItem {
    var title: String
    var icon: UIImage
}

protocol TabBarMenuSectionProtocol {
    var title: String { get }
    var items: [MenuSectionItem] { get }
}

enum TabBarMenuSection: CaseIterable, TabBarMenuSectionProtocol {
    case playground
    case groupAndStudy
    case homepage
    
    var title: String {
        switch self {
        case .playground:
            return I18N.TabBar.playground
        case .groupAndStudy:
            return I18N.TabBar.groupAndStudy
        case .homepage:
            return I18N.TabBar.homepage
        }
    }
    
    var items: [MenuSectionItem] {
        switch self {
        case .playground:
            return [MenuSectionItem(title: I18N.TabBar.Playground.write, 
                                    icon: DSKitAsset.Assets.icFabPencil.image)]
        case .groupAndStudy:
            return [
                MenuSectionItem(title: I18N.TabBar.GroupAndStudy.makeGroup, 
                                icon: DSKitAsset.Assets.icFabGroup.image),
                MenuSectionItem(title: I18N.TabBar.GroupAndStudy.makeLightGroup,
                                icon: DSKitAsset.Assets.icFabBolt.image),
                MenuSectionItem(title: I18N.TabBar.GroupAndStudy.writeFeed,
                                icon: DSKitAsset.Assets.icFabFire.image)
            ]
        case .homepage:
            return [
                MenuSectionItem(title: I18N.TabBar.Homepage.uploadArticle, 
                                icon: DSKitAsset.Assets.icFabHomepage.image),
            ]
        }
    }
}
