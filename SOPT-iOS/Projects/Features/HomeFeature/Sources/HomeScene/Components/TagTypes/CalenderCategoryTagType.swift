//
//  CalenderCategoryTagType.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 12/2/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

enum CalenderCategoryTagType: String {
    case event = "EVENT"
    case seminar = "SEMINAR"
    
    var text: String {
        switch self {
        case .event:
            return I18N.Home.DashBoard.Attendance.event
        case .seminar:
            return I18N.Home.DashBoard.Attendance.seminar
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .event:
            return DSKitAsset.Colors.success.color
        case .seminar:
            return DSKitAsset.Colors.secondary.color
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .event:
            return DSKitAsset.Colors.success.color.withAlphaComponent(0.2)
        case .seminar:
            return DSKitAsset.Colors.secondary.color.withAlphaComponent(0.2)
        }
    }
}
