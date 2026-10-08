//
//  MyAttendanceStateExtension.swift
//  AttendanceFeature
//
//  Created by devxsby on 2023/04/25.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import MDS

// 추후 MDSTag에 추가되면 사라질 파일
extension AttendanceStateType {
    
    var tagBackgroundColor: UIColor {
        switch self {
        case .attendance: return SemanticColor.Bg.Neutral.subtle
        case .absent: return SemanticColor.Bg.Danger.ghost
        case .tardy: return UIColor(hex: "#312A1E")
        case .participate: return SemanticColor.Bg.Neutral.subtle
        }
    }
    
    var tagTextColor: UIColor {
        switch self {
        case .attendance: return SemanticColor.Fg.Neutral.bold
        case .absent: return SemanticColor.Fg.Danger.default
        case .tardy: return SemanticColor.Fg.Attention.default
        case .participate: return SemanticColor.Fg.Neutral.bold
        }
    }
}
