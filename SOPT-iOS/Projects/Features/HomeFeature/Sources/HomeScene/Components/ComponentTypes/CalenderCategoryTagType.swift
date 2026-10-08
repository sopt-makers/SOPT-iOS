//
//  CalenderCategoryTagType.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 12/2/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import MDS

enum CalenderCategoryTagType: String {
    case event = "EVENT"
    case seminar = "SEMINAR"
    case jointSeminar = "JOINT_SEMINAR"
    case `break` = "BREAK"
    
    var text: String {
        switch self {
        case .event:
            return I18N.Home.DashBoard.Attendance.event
        case .seminar:
            return I18N.Home.DashBoard.Attendance.seminar
        case .jointSeminar:
            return I18N.Home.DashBoard.Attendance.jointSeminar
        case .break:
            return I18N.Home.DashBoard.Attendance.break
        }
    }
    
    var tagType: MDSTag.Variant {
        switch self {
        case .event:
                .secondary
        case .seminar, .jointSeminar:
                .primary
        case .break:
                .default
        }
    }
}
