//
//  CoffeeChatGenerationHistoryType.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 12/2/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

enum CoffeeChatGenerationHistoryTagType {
    case currentActivity
    case pastActivity
    
    var titleColor: UIColor {
        switch self {
        case .currentActivity:
            return DSKitAsset.Colors.secondary.color
        case .pastActivity:
            return DSKitAsset.Colors.gray200.color
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .currentActivity:
            return DSKitAsset.Colors.secondary.color.withAlphaComponent(0.2)
        case .pastActivity:
            return DSKitAsset.Colors.gray700.color
        }
    }
}
