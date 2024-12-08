//
//  RecruitmentStatusTagType.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 12/2/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

enum RecruitmentStatusTagType: String {
    case beforeStart = "BEFORE_START"
    case applyAble = "APPLY_ABLE"
    case recruitmentComplete = "RECRUITMENT_COMPLETE"
    
    var text: String {
        switch self {
        case .beforeStart:
            return I18N.Home.Group.beforeStart
        case .applyAble:
            return I18N.Home.Group.applyAble
        case .recruitmentComplete:
            return I18N.Home.Group.recruitmentComplete
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .beforeStart:
            return DSKitAsset.Colors.gray800.color
        case .applyAble:
            return DSKitAsset.Colors.gray800.color
        case .recruitmentComplete:
            return DSKitAsset.Colors.gray800.color
        }
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
