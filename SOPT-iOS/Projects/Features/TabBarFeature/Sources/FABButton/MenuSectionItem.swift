//
//  MenuSectionItem.swift
//  HomeFeature
//
//  Created by 성현주 on 11/30/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//


import Foundation
import UIKit

import Core
import DSKit


struct MenuSectionItem {
    var title: String
    var icon: UIImage
    var url: String
}

protocol FABMenuSectionProtocol {
    var title: String { get }
    var items: [MenuSectionItem] { get }
}

enum FABMenuSection: CaseIterable, FABMenuSectionProtocol {
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
                                    icon: DSKitAsset.Assets.icFabPencil.image, 
                                    url: ExternalURL.Playground.feedUpload)]
        case .groupAndStudy:
            return [
                MenuSectionItem(title: I18N.TabBar.GroupAndStudy.makeGroup, 
                                icon: DSKitAsset.Assets.icFabGroup.image, 
                                url: ExternalURL.Playground.makeGroup),
                MenuSectionItem(title: I18N.TabBar.GroupAndStudy.makeLightGroup,
                                icon: DSKitAsset.Assets.icFabBolt.image, 
                                url: ExternalURL.Playground.makeLightGroup),
                MenuSectionItem(title: I18N.TabBar.GroupAndStudy.writeFeed,
                                icon: DSKitAsset.Assets.icFabFire.image, 
                                url: ExternalURL.Playground.makeGroupFeed)
            ]
        case .homepage:
            return [
                MenuSectionItem(title: I18N.TabBar.Homepage.reviewUpload, 
                                icon: DSKitAsset.Assets.icFabHomepage.image, 
                                url: ExternalURL.Playground.blog),
            ]
        }
    }
}
