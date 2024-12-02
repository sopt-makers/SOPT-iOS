//
//  GroupCategoryType.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 12/2/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

enum GroupCategoryTagType: String {
    case event = "EVENT"
    case study = "STUDY"
    
    var text: String {
        switch self {
        case .event:
            return "행사"
        case .study:
            return "스터디"
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .event:
            return DSKitAsset.Colors.success.color
        case .study:
            return DSKitAsset.Colors.secondary.color
        }
    }
}
