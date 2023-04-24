//
//  MyAttendanceStateExtension.swift
//  AttendanceFeature
//
//  Created by devxsby on 2023/04/25.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

extension AttendanceStateType {
    
    public var image: UIImage {
        switch self {
        case .attendance: return DSKitAsset.Assets.opStateAttendance.image
        case .absent: return DSKitAsset.Assets.opStateAbsent.image
        case .tardy: return DSKitAsset.Assets.opStateTardy.image
        case .participate: return DSKitAsset.Assets.opStateParticipate.image
        }
    }
}
