//
//  HomeGroupPostModel+.swift
//  HomeFeatureInterface
//
//  Created by Jae Hyun Lee on 1/31/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Domain
import DSKit

public extension HomeGroupPostModel.Category {
    var textColor: UIColor {
        switch self {
        case .event:
            return DSKitAsset.Colors.success.color
        case .study:
            return DSKitAsset.Colors.secondary.color
        }
    }
}

public extension HomeGroupPostModel.Status {
    var textColor: UIColor {
        return DSKitAsset.Colors.gray800.color
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .beforeStart:
            return DSKitAsset.Colors.attention.color
        case .applyAble:
            return DSKitAsset.Colors.secondary.color
        case .recruitmentComplete:
            return DSKitAsset.Colors.gray100.color
        }
    }
}

